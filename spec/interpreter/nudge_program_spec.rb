#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('codeblock')
include Nudge


describe "Nudge Program parsing" do
  before(:each) do
    @parser = NudgeCodeblockParser.new()
  end
  
  describe ": initializing a new NudgeProgram from a string" do
    it "should check that it's been given a string" do
      lambda{NudgeProgram.new(2)}.should raise_error(
        ArgumentError, "NudgeProgram.new should be passed a string")
    end
    
    it "should keep the original string in #raw_code" do
      NudgeProgram.new("I'm a little teacup").raw_code.should == "I'm a little teacup"
    end
    
    it "should be possible to initialize it with an empty string" do
      lambda{NudgeProgram.new("")}.should_not raise_error
      NudgeProgram.new("").listing.should == ""
    end
  end
  
  describe ": parser should first break up programs into codeblock and footnotes" do
    describe "separating out the codeblock" do
      it "should read the codeblock into #code_section" do
        NudgeProgram.new("do int_add").code_section.should == "do int_add"
        NudgeProgram.new("block {}").code_section.should == "block {}"
        
        NudgeProgram.new("value «int» \n«int» 8").code_section.should == "value «int»"
        NudgeProgram.new("block {value «int» ref x2}\n \n«int» 8").code_section.should ==
          "block {value «int» ref x2}"
      end
    end
    
    describe ": capturing and preparing the footnotes" do
      it "should capture the footnote code into #footnote_section" do
        NudgeProgram.new("do int_add").footnote_section.should == ""
        NudgeProgram.new("block {}\n\n").footnote_section.should == ""
        
        NudgeProgram.new("value «int» \n«int» 8").footnote_section.should == "«int» 8"
        NudgeProgram.new("value «int» \n«int» 8 \n«code» value «bool»").footnote_section.should ==
          "«int» 8 \n«code» value «bool»"
      end
      
      it "should capture each individual footnote into #footnotes" do
        NudgeProgram.new("do int_add").footnotes.should == {}
        NudgeProgram.new("value «int» \n«bool» false").footnotes[:bool].should include("false")
        
        tricky = NudgeProgram.new("value «int» \n«int» 8 \n«code» value «bool»").footnotes
        tricky.keys.length.should == 2
        tricky[:code].should == ["value «bool»"]
      end
    end
  
    describe ": trimming whitespace from footnote values" do
      it "should ignore leading whitespace" do
        NudgeProgram.new("value «baz» \n«baz»\t\t8").parsed_footnotes[:baz][0].should == "8"
        NudgeProgram.new("value «baz» \n«baz»\n\n\n\n8").parsed_footnotes[:baz][0].should == "8"
        NudgeProgram.new("value «baz» \n«baz»      8").parsed_footnotes[:baz][0].should == "8"
        NudgeProgram.new("value «baz» \n«baz»8").parsed_footnotes[:baz][0].should == "8"
      end
      
      it "should should ignore trailing whitespace" do
        NudgeProgram.new("value «foo» \n«foo» 9\t\t").parsed_footnotes[:foo][0].should == "9"
        NudgeProgram.new("value «foo» \n«foo» 9\n\n\n\n").parsed_footnotes[:foo][0].should == "9"
        NudgeProgram.new("value «foo» \n«foo» 9     ").parsed_footnotes[:foo][0].should == "9"
      end
      
      it "should capture whitespace inside values" do
        NudgeProgram.new("value «bar» \n«bar» 9\t\t9").parsed_footnotes[:bar][0].should == "9\t\t9"
        NudgeProgram.new("value «bar» \n«bar» 9\n\n\n\n9").parsed_footnotes[:bar][0].should == "9\n\n\n\n9"
        NudgeProgram.new("value «bar» \n«bar» 9     9").parsed_footnotes[:bar][0].should == "9     9"
      end
      
      it "should trim whitespace between footnotes" do
        NudgeProgram.new("value «bar» \n«bar» 9\n  \n\t\n«baz»9").parsed_footnotes.keys.length.should == 2
        NudgeProgram.new("value «bar» \n«bar» 9\n  \n\t\n«baz»9").parsed_footnotes.keys.should include(:bar)
        NudgeProgram.new("value «bar» \n«bar» 9\n  \n\t\n«baz»9").parsed_footnotes.keys.should include(:baz)
      end
      
      it "should avoid capturing newlines between footnotes" do
        known_risk = NudgeProgram.new("block {value «mya»\nvalue «myb»}\n«myb» this is a b\n«mya» a")
        known_risk.parsed_footnotes[:myb][0].should == "this is a b"
      end
    end
  end
  
  
  describe ": code_section methods" do
    it "should have a #parses? method that returns true iff the code_section is valid" do
      NudgeProgram.new("do int_add").parses?.should == true
      NudgeProgram.new("block {}").parses?.should == true
      NudgeProgram.new("dofoo baz doo runrun").parses?.should == false
      NudgeProgram.new("").parses?.should == false
      
      NudgeProgram.new("value «bar» \n«bar» 9     9").parses?.should == true
      NudgeProgram.new("block {} «bar» 9     9").parses?.should == false
    end
    
    describe ": should have a #tidy attribute with the indented, one-point per line structure" do
      it "should work for one-line programs" do
        NudgeProgram.new("do    int_add").tidy.should == "do int_add"
        NudgeProgram.new("ref    x4").tidy.should == "ref x4"
        NudgeProgram.new("value \t\t «golly»").tidy.should == "value «golly»"
        NudgeProgram.new("block {}").tidy.should == "block {}"
      end
      
      it "should produce 2-space indents for nested program points" do
        NudgeProgram.new("block { ref \t x1}").tidy.should == "block {\n  ref x1}"
        NudgeProgram.new("block { do a do b do c}").tidy.should == "block {\n  do a\n  do b\n  do c}"
      end
      
      it "should outdent after the close of a nested block" do
        flat = "block { block { ref a } value «gah»}"
        liney = "block {\n  block {\n    ref a}\n  value «gah»}"
        NudgeProgram.new(flat).tidy.should == liney
      end
      
      it "should produce an empty string if called on a bad program" do
        NudgeProgram.new("nobody home boss «k2» •¡ß").tidy.should == ""
      end
      
      it "should work for really big programs" do
        jeez = "block {" + ("block { " * 20 + "block {}" + "}" * 20) * 3 + "}"
        NudgeProgram.new(jeez).tidy.split(/\n/).length.should == 64
      end
    end
  end
  
  
  describe "linked_code should contain the abstract syntax tree, plus associated_values" do
    it "should be a simple one-node tree for one-line code" do
      NudgeProgram.new("ref time").linked_code.should be_a_kind_of(ReferencePoint)
      NudgeProgram.new("do my_thing").linked_code.should be_a_kind_of(InstructionPoint)
      NudgeProgram.new("block {}").linked_code.should be_a_kind_of(CodeblockPoint)
      NudgeProgram.new("value «idjit»").linked_code.should be_a_kind_of(ValuePoint)
    end
    
    it "should be a CodeblockPoint with #contents set appropriately if it's a multiline program" do
      lt = NudgeProgram.new("block {ref a\nref b}")
      lt.linked_code.should be_a_kind_of(CodeblockPoint)
      lt.linked_code.contents.length.should == 2
      lt.linked_code.contents[0].should be_a_kind_of(ReferencePoint)
      lt.linked_code.contents[1].name.should == "b"
      
      bbb = NudgeProgram.new("block { block { block {}}}")
      bbb.linked_code.should be_a_kind_of(CodeblockPoint)
      bbb.linked_code.contents.length.should == 1
      bbb.linked_code.contents[0].contents[0].should be_a_kind_of(CodeblockPoint)
      bbb.linked_code.contents[0].contents[0].contents.should == []
    end
  end
  
  
  describe "#contains_codevalues? method" do
    it "should return true iff the raw code (including footnote_section) includes 'value «code»" do
      NudgeProgram.new("do int_add").contains_codevalues?.should == false
      NudgeProgram.new("value \t\t«code»").contains_codevalues?.should == true
      NudgeProgram.new("block {block {value \n «code»}}").contains_codevalues?.should == true
    end
  end
  
  
  # some examples worked by hand to test the
  #   depth-first association of values to footnotes
  #
  # @nasty:             |  associated values:
  # -------------       |  ------------------
  # block {             |
  #   value «code»      |  <- "value «foo»\n«foo» 1"
  #   value «code»      |  <- "block {value «code»}\n«code» value «foo»\n«foo» 2"
  #   value «foo»}      |  <- "3"
  # «code» value «foo»  |
  # «code» block {value «code»}
  # «foo» 1             |
  # «foo» 2             |
  # «code» value «foo»  |
  # «foo» 3             |
  #                     |
  #                     |
  # @boring:            |  associated values:
  # -------------       |  ------------------
  # block {             |
  #   value «code»}     |  <- "value «int»\n«int» 2"
  # «code» value «int»  |
  # «int» 2             |
  #                     |
  #                     |
  # @hofstadter1:       |  associated values:
  # -------------       |  ------------------
  # block {             |
  #   value «int»       |  <- "2"
  #   value «code»      |  <- "value «code»\n«code» value «int»\n«int» 33"
  #   value «int»}      |  <- "444"
  # «int» 2             |
  # «int» 33            |
  # «code» value «code» |
  # «int» 444           |
  # «code» value «int»  |
  
  
  describe "keep footnote values associated with proper program point Nodes" do
    it "should set the #value attribute of a ValuePoint" do
      simple = NudgeProgram.new("value «int» \n«int» 0")
      simple.linked_code.should be_a_kind_of(ValuePoint)
      simple.linked_code.raw.should == "0"
    end
    
    it "should set the value attribute even in a deeply nested statement" do
      deep = NudgeProgram.new("block { block { block {} block {value «int»}}} \n«int» 0")
      deep.linked_code.contents[0].contents[1].contents[0].raw.should == "0"
    end
    
    it "should map values correctly based on the type strings" do
      swapped = NudgeProgram.new("block {value «my_a»\nvalue «my_b»}\n«my_b» this is a b\n«my_a» a")
      swapped.linked_code.contents[0].raw.should == "a"
      swapped.linked_code.contents[1].raw.should == "this is a b"
    end
    
    it "should associate values in the order they appear" do
      swapped = NudgeProgram.new("block {value «my_a»\nvalue «my_a»}\n«my_a» one\n«my_a» two")
      swapped.linked_code.contents[0].raw.should == "one"
      swapped.linked_code.contents[1].raw.should == "two"
    end
    
    it "should leave nil values if it runs out of footnotes" do
      simple = NudgeProgram.new("value «int»")
      simple.linked_code.should be_a_kind_of(ValuePoint)
      simple.linked_code.raw.should == nil
    end
    
    describe "listing" do
      it "should produce the same thing as #tidy for a ReferencePoint program" do
        justrp = NudgeProgram.new("ref g8")
        justrp.listing.should == "ref g8"
      end
      
      it "should produce the same thing as #tidy for an InstructionPoint program" do
        justrp = NudgeProgram.new("do my_word")
        justrp.listing.should == "do my_word"
      end
      
      it "should produce the same thing as #tidy for a CodeblockPoint program without footnotes" do
        tree1 = NudgeProgram.new("block {\t\t ref g}")
        tree1.listing.should == "block {\n  ref g}"
        tree2 = NudgeProgram.new("block {\t\t do a\ndo b\n \n do c\n do d}")
        tree2.listing.should == tree2.tidy
      end
      
      it "should produce the same thing as #tidy for a CodeblockPoint program with unassigned footnotes" do
        dangling = NudgeProgram.new("block {\t\t value «a»\nvalue «b»\n \n value «c»}")
        dangling.listing.should == dangling.tidy
      end
      
      it "should put out the tidy form AND the footnotes in the right order" do
        withfn = NudgeProgram.new("value \t\t«int» \n«int» \t\t\n 0")
        withfn.listing.should == "value «int» \n«int» 0"
        
        nasty = "block {value «code» \nvalue «code» \nvalue «foo»}\n«code» value «foo»\n«code» block {value «code»}\n«foo» 1\n«foo» 2\n«code» value «foo»\n«foo» 3"
        once_around = NudgeProgram.new(nasty).listing
        once_around.should == NudgeProgram.new(once_around).listing
      end
    end
    
    describe "handling complex nested CODE values is hard!" do
      before(:each) do
        @hofstadter1 = <<-END
block { value «int» value «code» value «int»}
«int» 2
«int» 33
«code» value «code»
«int» 444
«code» value «int»
          END
      end
      
      it "should associate values in a depth-first way (into «code» values)" do
        we_think = NudgeProgram.new(@hofstadter1)
        we_think.contains_codevalues?.should == true
        we_think.tidy.should == "block {\n  value «int»\n  value «code»\n  value «int»}"
        we_think.linked_code.contents[0].raw.should == "2"
        we_think.linked_code.contents[1].raw.should ==
          "value «code»\n«code» value «int»\n«int» 33"
        we_think.linked_code.contents[2].raw.should == "444"
        we_think.listing.should == 
        "block {\n  value «int»\n  value «code»\n  value «int»} " +
        "\n«int» 2\n«code» value «code»\n«code» value «int»\n«int» 33\n«int» 444"
      end
    end
    
  end
  
  describe "contains_valuepoints?" do
    it "should accept a string and return true if it contains any «» markup AT ALL" do
      np = NudgeProgram.new("")
      np.contains_valuepoints?("value «foo»").should == true
      np.contains_valuepoints?("block {value «foo_3»}").should == true
      np.contains_valuepoints?("value «a»").should == true
      np.contains_valuepoints?("««»»").should == false
      np.contains_valuepoints?("boring old crap").should == false
      np.contains_valuepoints?("misleading «something»").should == false
    end
  end
  
  
  describe "pursue_more_footnotes method" do
    before(:each) do
      @nasty = "block {value «code» \nvalue «code» \nvalue «foo»}\n«code» value «foo»\n«code» block {value «code»}\n«foo» 1\n«foo» 2\n«code» value «foo»\n«foo» 3"
      @simple = "block {value «code»}\n«code» value «int»\n«int» 2"
      @boring = "value «code»\n«code» block {}"
      @stringy = "value «code»\n«code» value «code»\n«code» value «code»\n«code» do X"
      @filler = '['+ (" \n "*100) + ']'
      @spacey = "value «code»\n«code» value «spacer»\n«spacer»#{@filler}"
      @staged_program = NudgeProgram.new("")
      
      def reprocess_using(new_code)
        @staged_program.instance_variable_set(:@raw_code,new_code)
        @staged_program.program_split!
        @staged_program.relink_code!
      end
    end
    
    it "should determine if the listing contains any ValuePoints if it is type code" do
      @staged_program.should_receive(:contains_valuepoints?).with("block {}")
      reprocess_using(@boring)
    end
    
    it "should (in the end) return the collected_footnotes string for this depth-first traversal" do
      reprocess_using(@nasty)
      @staged_program.linked_code.contents[0].raw.should == "value «foo»\n«foo» 1"
      @staged_program.linked_code.contents[1].raw.should ==
        "block {value «code»}\n«code» value «foo»\n«foo» 2"
      @staged_program.linked_code.contents[2].raw.should == "3"
      
      reprocess_using(@simple)
      @staged_program.linked_code.contents[0].raw.should == "value «int»\n«int» 2"
      
      reprocess_using(@boring)
      @staged_program.linked_code.raw.should == "block {}"
      
      reprocess_using(@stringy)
      @staged_program.linked_code.raw.should == "value «code»\n«code» value «code»\n«code» do X"
      
      reprocess_using(@spacey)
      @staged_program.linked_code.raw.should == "value «spacer»\n«spacer» #{@filler}"
    end
  end
  
  
  describe "preserving unused footnotes" do
    before(:each) do
      @all_extras = "value «foo»\n«bar» baz\n«qux» nothing"
      @all_used = "value «foo»\n«foo» bar"
      
    end
    it "should collect unused footnote strings in an Array called #unused_footnotes" do
      NudgeProgram.new(@all_extras).unused_footnotes.should include("«bar» baz")
      NudgeProgram.new(@all_extras).unused_footnotes.should include("«qux» nothing")
      
      NudgeProgram.new(@all_used).unused_footnotes.should be_empty
    end
    
    it "should preserve the unused footnotes at the end of #listing" do
      NudgeProgram.new(@all_extras).listing.should include("«bar» baz")
    end
  end
  
  
  
  describe ": handling malformed programs" do
    it "should interpret an empty string as no code at all" do
      huh = NudgeProgram.new("")
      huh.code_section.should == ""
      huh.linked_code.should == nil
      huh.footnote_section.should == ""
      huh.footnotes.should == {} # they didn't get used
    end
    
    it "should interpret an unparseable codesection as no code at all, but keep the footnotes" do
      got_nuthin = NudgeProgram.new("block { hunh \n«int» 2")
      got_nuthin.code_section.should == "block { hunh"
      got_nuthin.linked_code.should == nil
      got_nuthin.footnote_section.should == "«int» 2"
      got_nuthin.footnotes.should == {:int => ["2"]} # it's not been used
    end
    
    
    it "should read values linking to missing footnotes as linked to 'nil'" do
      # nasty_shorter:     |  associated values:
      # -------------       |  ------------------
      # block {             |
      #   value «code»      |  <- "value «foo»\n«foo» 1"
      #   value «code»      |  <- "block {value «code»}"
      #   value «foo»}      |  <- nil
      # «code» value «foo»  |
      # «code» block {value «code»}
      # «foo» 1             |
      
      nasty_shorter = "block {value «code» \nvalue «code» \nvalue «foo»}\n«code» value «foo»\n«code» block {value «code»}\n«foo» 1"
      shortstop = NudgeProgram.new(nasty_shorter)
      shortstop.linked_code.contents[0].raw.should == "value «foo»\n«foo» 1"
      shortstop.linked_code.contents[1].raw.should == "block {value «code»}"
      shortstop.linked_code.contents[2].raw.should == nil
    end
    
    it "should collect unused footnotes" do
      hmm = NudgeProgram.new("do int_add\n«nob» nothing")
      hmm.footnotes[:nob].should include("nothing")
    end
    
    it "should act as specified above when one or more footnote is unparseable" do
      # stupid_shorter:    |  associated values:
      # -------------       |  ------------------
      # block {             |
      #   value «code»      |  <- "value «foo»\n«foo» 1"
      #   value «code»      |  <- "some junk"
      #   value «foo»}      |  <- nil
      # «code» value «foo»  |
      # «code» some junk    |
      # «foo» 1             |
      
      stupid_shorter = "block {value «code» \nvalue «code» \nvalue «foo»}\n«code» value «foo»\n«code» some junk\n«foo» 1"
      busted = NudgeProgram.new(stupid_shorter)
      busted.linked_code.contents[0].raw.should == "value «foo»\n«foo» 1"
      busted.linked_code.contents[1].raw.should == "some junk"
      busted.linked_code.contents[2].raw.should == nil
      
    end
  end
  
  
  describe "maintaining integrity through parsing and listing cycles" do
    before(:each) do
      @extras = "block {\nvalue «code»\nvalue «code»\nvalue «foo»}\n«code» value «foo»\n«code» block {value «code»}\n«foo» 1\n«foo» 2\n«code» value «foo»\n«foo» 3\n«bar» baz"
    end
    
    it "should have all the same footnotes it started with" do
      original_fn = @extras.partition( /^(?=«)/ )[2].split( /^(?=«)/ ).collect {|fn| fn.strip}
      new_fn = NudgeProgram.new(@extras).listing.partition( /^(?=«)/ )[2].
        split( /^(?=«)/ ).collect {|fn| fn.strip}
      
      # original_fn.length.should == new_fn.length
      original_fn.sort.should == new_fn.sort
    end
  end
  
  
  describe "[] method" do
    before(:each) do
      @bigger_tree = "block { value «code» value «int»}\n«int»1\n«code» value «int»\n«int» 2"
    end
    
    it "should raise an ArgumentError if the index is 0 or less" do
      lambda{NudgeProgram.new("block {}")[-2]}.should raise_error(ArgumentError)
      lambda{NudgeProgram.new("block {}")[0]}.should raise_error(ArgumentError)
      lambda{NudgeProgram.new("block {}")[1]}.should_not raise_error(ArgumentError)
    end
    
    it "should raise an ArgumentError if the index is more than self.points" do
      lambda{NudgeProgram.new("block {}")[4]}.should raise_error(ArgumentError)
      lambda{NudgeProgram.new("block {}")[2]}.should raise_error(ArgumentError)
      lambda{NudgeProgram.new("block {}")[1]}.should_not raise_error(ArgumentError)
    end
    
    it "should return a single numbered point of the #linked_code tree" do
      NudgeProgram.new(@bigger_tree)[1].should be_a_kind_of(ProgramPoint)
      NudgeProgram.new(@bigger_tree)[3].should be_a_kind_of(ProgramPoint)
    end
    
    it "should return the right ProgramPoint" do
      caught = NudgeProgram.new(@bigger_tree)[3]
      caught.should be_a_kind_of(ValuePoint)
      caught.value.should == 2
      NudgeProgram.new(@bigger_tree)[2].listing_parts[1].should == "«code» value «int»\n«int» 1"
    end
  end
  
  
  describe "deep_copy" do
    it "should return a copy of the NudgeProgram that contains NONE of the same object_ids" do
      tree = "block { value «code» value «int»}\n«int»1\n«code» value «int»\n«int» 2"
      start = NudgeProgram.new(tree)
      cloned = start.clone
      
      # expected behavior from #clone
      cloned.linked_code.collect{|node| node.object_id}.should ==
        start.linked_code.collect{|node| node.object_id}
      
      deeply = start.deep_copy
      0.upto(2) {|i| deeply.linked_code.collect{|node| node.object_id}[i].should_not ==
        start.linked_code.collect{|node| node.object_id}[i] }
      
      
    end
  end
  
  describe "#replace_point method" do
    before(:each) do
      @bigger_tree = "block { value «code» value «int»}\n«int»1\n«code» value «int»\n«int» 2"
      @deeper_tree = "block { block {ref a block {ref b}} ref c}"
      @starter = NudgeProgram.new(@bigger_tree)
      @new_chunk = ReferencePoint.new("HI")
    end
    
    it "should raise an ArgumentError if the index is 0 or less" do
      lambda{@starter.replace_point(-8,@new_chunk)}.should raise_error(ArgumentError)
      lambda{@starter.replace_point(0,@new_chunk)}.should raise_error(ArgumentError)
    end
    
    it "should raise an ArgumentError if the index is more than self.points" do
      lambda{@starter.replace_point(9919,@new_chunk)}.should raise_error(ArgumentError)
    end
    
    it "should raise an ArgumentError if the second argument isn't a ProgramPoint" do
      lambda{@starter.replace_point(1,"hello")}.should raise_error(ArgumentError)
    end
    
    it "should return a new NudgeProgram based on the new code if which=1" do
      result = @starter.replace_point(1,@new_chunk)
      result.should be_a_kind_of(NudgeProgram)
      result.listing.should == "ref HI"
    end
    
    it "should not damage the invoking NudgeProgram" do
      result = @starter.replace_point(1,@new_chunk)
      @starter.raw_code.should == @bigger_tree
    end
    
    it "should return a new NudgeProgram" do
      result = @starter.replace_point(2,@new_chunk)
      result.should be_a_kind_of(NudgeProgram)
    end
    
    it "should return a new NudgeProgram with the right ProgramPoint replaced in its linked_code" do
      # untouched = "block {\n  block {\n    ref a\n    block {\n      ref b}}\n  ref c}"
      reffy = NudgeProgram.new(@deeper_tree)
      
      result = reffy.replace_point(2,@new_chunk)
      result.listing.should == "block {\n  ref HI\n  ref c}"     
      
      result = reffy.replace_point(3,@new_chunk)
      result.listing.should == "block {\n  block {\n    ref HI\n    block {\n      ref b}}\n  ref c}"
      
      result = reffy.replace_point(4,@new_chunk)
      result.listing.should == "block {\n  block {\n    ref a\n    ref HI}\n  ref c}"
      
      result = reffy.replace_point(5,@new_chunk)
      result.listing.should == "block {\n  block {\n    ref a\n    block {\n      ref HI}}\n  ref c}"
      
      result = reffy.replace_point(6,@new_chunk)
      result.listing.should == "block {\n  block {\n    ref a\n    block {\n      ref b}}\n  ref HI}"
    end
    
    it "should produce the expected footnotes in the resulting program" do
      valueful = NudgeProgram.new(
        "block {value «code» value «code»}\n«code»block {value «int»}\n«int» 7\n«code» value «bool»")
      addedvalue = ValuePoint.new("foo","•••")
      
      valueful.replace_point(1,addedvalue).listing.should ==
        "value «foo» \n«foo» •••"
        
      valueful.replace_point(2,addedvalue).listing.should ==
        "block {\n  value «foo»\n  value «code»} \n«foo» •••\n«code» value «bool»"
      
      valueful.replace_point(3,addedvalue).listing.should ==
        "block {\n  value «code»\n  value «foo»} \n«code» block {value «int»}\n«int» 7\n«foo» •••"
    end 
  end
  
  
  describe "#delete_point method" do
    before(:each) do
      @tree_with_values = NudgeProgram.new(
        "block { value «code» value «int»}\n«int»1\n«code» value «int»\n«int» 2")
      @lodgepole_tree = NudgeProgram.new(
        "block{block{block{block{block{block {ref a}}}}}}")
    end
    
    it "should raise an ArgumentError if the index is 0 or less" do
      lambda{@tree_with_values.delete_point(-8)}.should raise_error(ArgumentError)
      lambda{@tree_with_values.delete_point(0)}.should raise_error(ArgumentError)
    end
    
    it "should raise an ArgumentError if the index is more than self.points" do
      lambda{@tree_with_values.delete_point(10000)}.should raise_error(ArgumentError)
    end
    
    it "should return a new empty NudgeProgram if which=1" do
      result = @tree_with_values.delete_point(1)
      result.should be_a_kind_of(NudgeProgram)
      result.listing.should == ""
      result.linked_code.should == nil
    end
    
    it "should not damage the invoking NudgeProgram" do
      starting = @tree_with_values.listing
      result = @tree_with_values.delete_point(1)
      @tree_with_values.listing.should == starting
    end
    
    it "should return a new NudgeProgram" do
      result = @tree_with_values.delete_point(2)
      result.should be_a_kind_of(NudgeProgram)
    end
    
    it "should return a new NudgeProgram with the right ProgramPoint deleted" do
      # "block {\n  block {\n    block {\n      block {\n        block {\n          block {\n            ref a}}}}}}"
      result = @lodgepole_tree.delete_point(1)
      result.listing.should == ""
      
      result = @lodgepole_tree.delete_point(2)
      result.listing.should == "block {}"     
      
      result = @lodgepole_tree.delete_point(4)
      result.listing.should == "block {\n  block {\n    block {}}}"     
      
      result = @lodgepole_tree.delete_point(7)
      result.listing.should == "block {\n  block {\n    block {\n      block {\n        block {\n          block {}}}}}}"     
    end
    
    it "should leave the expected footnotes in the resulting program" do
      valueful = NudgeProgram.new(
        "block {value «code» value «code»}\n«code»block {value «int»}\n«int» 7\n«code» value «bool»")
      
      valueful.delete_point(1).listing.should ==
        ""
        
      valueful.delete_point(2).listing.should ==
        "block {\n  value «code»} \n«code» value «bool»"
        
      valueful.delete_point(3).listing.should ==
        "block {\n  value «code»} \n«code» block {value «int»}\n«int» 7"
    end 
  end
end
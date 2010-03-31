#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('codeblock')
include Nudge


describe "Nudge Program parsing" do
  
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
      NudgeProgram.new("").blueprint.should == ""
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
    end
  
    describe ": trimming whitespace from footnote values" do
      it "should ignore leading whitespace"
      
      it "should should ignore trailing whitespace"
      
      it "should capture whitespace inside values"
      
      it "should trim whitespace between footnotes"
      
      it "should avoid capturing newlines between footnotes"
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
    
    it "should return a NilPoint if the code can't be interpreted" do
      NudgeProgram.new("some random junk that ain't a program").linked_code.should be_a_kind_of(NilPoint)
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
      simple.linked_code.value.should == nil
    end
    
    describe "blueprint" do
      it "should produce the same thing as #tidy for a ReferencePoint program" do
        justrp = NudgeProgram.new("ref g8")
        justrp.blueprint.should == "ref g8"
      end
      
      it "should produce the same thing as #tidy for an InstructionPoint program" do
        justrp = NudgeProgram.new("do my_word")
        justrp.blueprint.should == "do my_word"
      end
      
      it "should produce the same thing as #tidy for a CodeblockPoint program without footnotes" do
        tree1 = NudgeProgram.new("block {\t\t ref g}")
        tree1.blueprint.should == "block {\n  ref g}"
        tree2 = NudgeProgram.new("block {\t\t do a\ndo b\n \n do c\n do d}")
        tree2.blueprint.should == tree2.tidy
      end
      
      it "should produce the same thing as #tidy for a CodeblockPoint program with unassigned footnotes" do
        dangling = NudgeProgram.new("block {\t\t value «a»\nvalue «b»\n \n value «c»}")
        dangling.blueprint.should == dangling.tidy
      end
      
      it "should put out the tidy form AND the footnotes in the right order" do
        withfn = NudgeProgram.new("value \t\t«int» \n«int» \t\t\n 0")
        withfn.blueprint.should == "value «int» \n«int» 0"
        
        nasty = "block {value «code» \nvalue «code» \nvalue «foo»}\n«code» value «foo»\n«code» block {value «code»}\n«foo» 1\n«foo» 2\n«code» value «foo»\n«foo» 3"
        once_around = NudgeProgram.new(nasty).blueprint
        once_around.should == NudgeProgram.new(once_around).blueprint
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
        we_think.blueprint.should == 
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
    
    it "should preserve the unused footnotes at the end of #blueprint" do
      NudgeProgram.new(@all_extras).blueprint.should include("«bar» baz")
    end
  end
  
  
  
  describe ": handling malformed programs" do
    it "should interpret an empty string as no code at all" do
      huh = NudgeProgram.new("")
      huh.code_section.should == ""
      huh.linked_code.should be_a_kind_of(NilPoint)
      huh.footnote_section.should == ""
      huh.footnotes.should == {} # they didn't get used
    end
    
    it "should interpret an unparseable codesection as no code at all, and drop footnotes" do
      got_nuthin = NudgeProgram.new("block { hunh \n«int» 2")
      got_nuthin.code_section.should == "block { hunh"
      got_nuthin.linked_code.should be_a_kind_of(NilPoint)
      got_nuthin.footnote_section.should == "«int» 2"
      got_nuthin.footnotes.should == {} # it's not been used
    end
    
    
    it "should include a footnote for every reference, even if it has to create an empty one" do
      nasty =
        "block {value «code»\nvalue «code» \nvalue «foo»}\n«code» value «foo»\n«code» block {value «code»}\n«foo» 1"
        
      shortstop = NudgeProgram.new(nasty)
      r0 = "value «code» \n«code» value «foo»\n«foo» 1"
      r1 = "value «code» \n«code» block {value «code»}\n«code»"
      r2 = "value «foo» \n«foo»"
      shortstop.linked_code.contents[0].blueprint.should == r0
      shortstop.linked_code.contents[1].blueprint.should == r1
      
    end
    
    it "should collect unused footnotes" do
      hmm = NudgeProgram.new("do int_add\n«nob» nothing")
      hmm.footnotes["nob"].should include("nothing")
    end
    
    it "should act as specified above when one or more footnote is unparseable" do
      
      stupid_shorter = "block {value «code» \nvalue «code» \nvalue «foo»}\n«code» value «foo»\n«code» some junk\n«foo» 1"
      busted = NudgeProgram.new(stupid_shorter)
      busted.linked_code.contents[0].raw.should == "value «foo»\n«foo» 1"
      busted.linked_code.contents[1].raw.should == "some junk"
      busted.linked_code.contents[2].raw.should == nil
    end
  end
  
  
  describe "maintaining integrity through parsing and blueprint cycles" do
    before(:each) do
      @extras = "block {\nvalue «code»\nvalue «code»\nvalue «foo»}\n«code» value «foo»\n«code» block {value «code»}\n«foo» 1\n«foo» 2\n«code» value «foo»\n«foo» 3\n«bar» baz"
    end
    
    it "should have all the same footnotes it started with" do
      original_fn = @extras.partition( /^(?=«)/ )[2].split( /^(?=«)/ ).collect {|fn| fn.strip}
      new_fn = NudgeProgram.new(@extras).blueprint.partition( /^(?=«)/ )[2].
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
      NudgeProgram.new(@bigger_tree)[2].blueprint_parts[1].should == "«code» value «int»\n«int» 1"
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
  
  
  describe "#cleanup_strings_from_linked_code!" do
    it "should [re-]derive the NudgeProgram's #raw_code, #code_section and #footnote_section" do
      mess_with_me = NudgeProgram.new("value «foo»\n«foo» bar\n«baz» qux")
      mess_with_me.raw_code = "oh, that's really funny"
      mess_with_me.code_section = "totally: ha"
      mess_with_me.footnote_section = "no, really, I am laughing"
      
      mess_with_me.cleanup_strings_from_linked_code!
      mess_with_me.raw_code.should_not == "oh, that's really funny"
      mess_with_me.footnote_section.should == "«foo» bar\n«baz» qux"
      
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
      result.blueprint.should == "ref HI"
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
      result.blueprint.should == "block {\n  ref HI\n  ref c}"     
      
      result = reffy.replace_point(3,@new_chunk)
      result.blueprint.should == "block {\n  block {\n    ref HI\n    block {\n      ref b}}\n  ref c}"
      
      result = reffy.replace_point(4,@new_chunk)
      result.blueprint.should == "block {\n  block {\n    ref a\n    ref HI}\n  ref c}"
      
      result = reffy.replace_point(5,@new_chunk)
      result.blueprint.should == "block {\n  block {\n    ref a\n    block {\n      ref HI}}\n  ref c}"
      
      result = reffy.replace_point(6,@new_chunk)
      result.blueprint.should == "block {\n  block {\n    ref a\n    block {\n      ref b}}\n  ref HI}"
    end
    
    it "should produce the expected footnotes in the resulting program" do
      valueful = NudgeProgram.new(
        "block {value «code» value «code»}\n«code»block {value «int»}\n«int» 7\n«code» value «bool»")
      addedvalue = ValuePoint.new("foo","•••")
      
      valueful.replace_point(1,addedvalue).blueprint.should ==
        "value «foo» \n«foo» •••"
        
      valueful.replace_point(2,addedvalue).blueprint.should ==
        "block {\n  value «foo»\n  value «code»} \n«foo» •••\n«code» value «bool»\n«bool»"
      
      valueful.replace_point(3,addedvalue).blueprint.should ==
        "block {\n  value «code»\n  value «foo»} \n«code» block {value «int»}\n«int» 7\n«foo» •••"
    end 
    
    it "should synchronize the #raw_code, #footnote_section #code_section strings" do
      starting_from = NudgeProgram.new("value «foo»\n«foo» bar\n«baz» qux")
      starting_raw = starting_from.raw_code
      starting_code = starting_from.code_section
      starting_fn = starting_from.footnote_section
      
      revised = starting_from.replace_point(1,CodeblockPoint.new)
      
      revised.blueprint.should == "block {} \n«baz» qux"
      revised.raw_code.should == "block {} \n«baz» qux"
      revised.footnote_section.should == "«baz» qux"
      revised.code_section.should == "block {}"
    end
    
    it "should not affect unused footnotes" do
      unclear_on_concept = NudgeProgram.new("value «int»\n«bool» false")
      unclear_on_concept.replace_point(1,ReferencePoint.new("x")).footnote_section.should == "«bool» false"
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
    
    it "should return a NudgeProgram with code 'block {}' if which=1" do
      result = @tree_with_values.delete_point(1)
      result.should be_a_kind_of(NudgeProgram)
      result.blueprint.should == "block {}"
      result.linked_code.should_not == nil
    end
    
    it "should not damage the invoking NudgeProgram" do
      starting = @tree_with_values.blueprint
      result = @tree_with_values.delete_point(1)
      @tree_with_values.blueprint.should == starting
    end
    
    it "should return a new NudgeProgram" do
      result = @tree_with_values.delete_point(2)
      result.should be_a_kind_of(NudgeProgram)
    end
    
    it "should return a new NudgeProgram with the right ProgramPoint deleted" do
      result = @lodgepole_tree.delete_point(1)
      result.blueprint.should == "block {}"
      
      result = @lodgepole_tree.delete_point(2)
      result.blueprint.should == "block {}"     
      
      result = @lodgepole_tree.delete_point(4)
      result.blueprint.should == "block {\n  block {\n    block {}}}"     
      
      result = @lodgepole_tree.delete_point(7)
      result.blueprint.should == "block {\n  block {\n    block {\n      block {\n        block {\n          block {}}}}}}"     
    end
    
    it "should leave the expected footnotes in the resulting program" do
      valueful = NudgeProgram.new(
        "block {value «code» value «code»}\n«code»block {value «int»}\n«int» 7\n«code» value «bool»")
      
      valueful.delete_point(1).blueprint.should ==
        "block {}"
        
      valueful.delete_point(2).blueprint.should ==
        "block {\n  value «code»} \n«code» value «bool»\n«bool»"
        
      valueful.delete_point(3).blueprint.should ==
        "block {\n  value «code»} \n«code» block {value «int»}\n«int» 7"
    end
    
    it "should not delete unused footnotes" do
      unclear_on_concept = NudgeProgram.new("value «int»\n«bool» false")
      unclear_on_concept.delete_point(1).blueprint.should == "block {} \n«bool» false"
    end
  end
  
  
  describe "#insert_point_before method" do
    before(:each) do
      @bigger_tree = "block { value «code» value «int»}\n«int»1\n«code» value «int»\n«int» 2"
      @deeper_tree = "block { block {ref a block {ref b}} ref c}"
      @starter = NudgeProgram.new(@bigger_tree)
      @new_chunk = ReferencePoint.new("HI")
    end
    
    it "should raise an ArgumentError if the index is 0 or less" do
      lambda{@starter.insert_point_before(0,@new_chunk)}.should raise_error(ArgumentError)
      lambda{@starter.insert_point_before(1,@new_chunk)}.should_not raise_error(ArgumentError)
    end
    
    it "should raise an ArgumentError if the index is bigger than old_code.points" do
      lambda{@starter.insert_point_before(4,@new_chunk)}.should_not raise_error(ArgumentError)
      lambda{@starter.insert_point_before(5,@new_chunk)}.should raise_error(ArgumentError)
    end
    
    it "should raise an ArgumentError if the second argument isn't a ProgramPoint" do
      lambda{@starter.insert_point_before(3,"not valid")}.should raise_error(ArgumentError)
    end
    
    it "should create a block around the new code and the old code if pos = 1" do
      in_the_front = @starter.insert_point_before(1,@new_chunk)
      in_the_front.linked_code.should be_a_kind_of(CodeblockPoint)
      in_the_front[2].should be_a_kind_of(ReferencePoint)
      in_the_front[3].should be_a_kind_of(CodeblockPoint)
      in_the_front.points.should == 1 + @starter.points + 1 # from the insertion
    end
    
    it "should create a block around the old code and the new code if pos = old.pts+1" do
      in_the_back = @starter.insert_point_before(4,@new_chunk)
      in_the_back.linked_code.should be_a_kind_of(CodeblockPoint)
      in_the_back[2].should be_a_kind_of(CodeblockPoint)
      in_the_back[5].should be_a_kind_of(ReferencePoint)
      in_the_back.points.should == 1 + @starter.points + 1 # from the insertion
    end
    
    it "should return a new NudgeProgram with the right ProgramPoint inserted in its linked_code" do
      in_the_midst = @starter.insert_point_before(2,@new_chunk)
      # "block { ref HI value «code» value «int»}\n«int»1\n«code» value «int»\n«int» 2"
      
      in_the_midst.linked_code.should be_a_kind_of(CodeblockPoint)
      in_the_midst[2].should be_a_kind_of(ReferencePoint)
      in_the_midst[3].should be_a_kind_of(ValuePoint)
      in_the_midst.points.should == @starter.points + 1 # from the insertion
    end
    
    
    it "should not change the invoking NudgeProgram" do
      old_code = @starter.blueprint
      in_the_midst = @starter.insert_point_before(2,@new_chunk)
      @starter.blueprint.should == old_code
      in_the_midst.blueprint.should_not == old_code
    end
    
    it "should return a new NudgeProgram" do
      old_id = @starter.object_id
      in_the_midst = @starter.insert_point_before(2,@new_chunk)
      in_the_midst.object_id.should_not == old_id
    end
    
    it "should produce the expected footnotes in the resulting program" do
      complicated = @starter.insert_point_before(3,@starter.linked_code.clone)
      complicated.blueprint.should == "block {\n  value «code»\n  block {\n    value «code»\n    value «int»}\n  value «int»} \n«code» value «int»\n«int» 1\n«code» value «int»\n«int» 1\n«int» 2\n«int» 2"
    end
    
    it "should synchronize the #raw_code, #footnote_section #code_section strings" do
      complicated = @starter.insert_point_before(3,@starter.linked_code.clone)
      complicated.raw_code.should_not == @starter.raw_code
      complicated.raw_code.should == complicated.blueprint
      complicated.footnote_section.should_not == @starter.footnote_section
      complicated.footnote_section.should ==
        "«code» value «int»\n«int» 1\n«code» value «int»\n«int» 1\n«int» 2\n«int» 2"
      complicated.code_section.should_not == @starter.code_section
    end
    
    it "should work correctly with unused footnotes" do
      wordy = NudgeProgram.new("block {}\n«foo» bar")
      interrupted = wordy.insert_point_before(1,@starter.linked_code)
      interrupted.footnote_section.should include("foo")
    end
  end
  
end
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
  
  
  describe "keep footnote values associated with proper program point Nodes" do
    it "should set the #value attribute of a ValuePoint" do
      simple = NudgeProgram.new("value «int» \n«int» 0")
      simple.linked_code.should be_a_kind_of(ValuePoint)
      simple.linked_code.value.should == "0"
    end
    
    it "should set the value attribute even in a deeply nested statement" do
      deep = NudgeProgram.new("block { block { block {} block {value «int»}}} \n«int» 0")
      deep.linked_code.contents[0].contents[1].contents[0].value.should == "0"
    end
    
    it "should map values correctly based on the type strings" do
      swapped = NudgeProgram.new("block {value «my_a»\nvalue «my_b»}\n«my_b» this is a b\n«my_a» a")
      swapped.linked_code.contents[0].value.should == "a"
      swapped.linked_code.contents[1].value.should == "this is a b"
    end
    
    it "should associate values in the order they appear" do
      swapped = NudgeProgram.new("block {value «my_a»\nvalue «my_a»}\n«my_a» one\n«my_a» two")
      swapped.linked_code.contents[0].value.should == "one"
      swapped.linked_code.contents[1].value.should == "two"
    end
    
    it "should leave nil values if it runs out of footnotes" do
      simple = NudgeProgram.new("value «int»")
      simple.linked_code.should be_a_kind_of(ValuePoint)
      simple.linked_code.value.should == nil
    end
    
    describe "handling complex nested CODE values" do
      it "should associate all necessary footnotes with CODE values" do
        pending
        hofstadter1 = NudgeProgram.new("value «code» \n«code» value «code»\n«code» value «int»\n«int» 777")
        hofstadter1.linked_code.value.should == "value «code»"
        # result should be what??? 
      end

      it "should first associate values in the root tree" do
        pending
        hofstadter2 = NudgeProgram.new("value «code» \n«code» value «code»\n«int» 777")
        # result should have a value in root tree, but no footnote in that
      end
    end
    
  end
  
  
  
  
  describe ": handling malformed programs" do
    it "should interpret an empty string as no code at all" do
      huh = NudgeProgram.new("")
      huh.code_section.should == ""
      huh.footnote_section.should == ""
      huh.footnotes.should == {}
    end
    
    it "should interpret an unparseable codesection as no code at all, but keep footnotes"
    
    
    it "should read values linking to missing footnotes as linked to 'nil'"
    
    it "should collect unused footnotes" do
      hmm = NudgeProgram.new("do int_add\n«nob» nothing")
      hmm.footnotes[:nob].should include("nothing")
    end
    
    it "should act as specified above for unparseable programs with footnotes"
    it "should act as specified above when one or more footnote is unparseable"
  end
  
  
  
end

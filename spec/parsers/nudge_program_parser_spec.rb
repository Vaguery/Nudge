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
    
    describe "capturing and preparing the footnotes" do
      it "should capture the footnote code into #footnote_section" do
        NudgeProgram.new("do int_add").footnote_section.should == ""
        NudgeProgram.new("block {}\n\n").footnote_section.should == ""
        
        NudgeProgram.new("value «int» \n«int» 8").footnote_section.should == "«int» 8"
        NudgeProgram.new("value «int» \n«int» 8 \n«code» value «bool»").footnote_section.should ==
          "«int» 8 \n«code» value «bool»"
      end
      
      it "should capture each individual footnote into #footnotes" do
        NudgeProgram.new("do int_add").footnotes.should == []
        NudgeProgram.new("value «int» \n«int» 8").footnotes.should include(["int","8"])
        
        tricky = NudgeProgram.new("value «int» \n«int» 8 \n«code» value «bool»").footnotes
        tricky.length.should == 2
        tricky[1].should == ["code","value «bool»"]
      end
    end
  
    describe "trimming whitespace from footnote values" do
      it "should ignore leading whitespace" do
        NudgeProgram.new("value «baz» \n«baz»\t\t8").footnotes[0][1].should == "8"
        NudgeProgram.new("value «baz» \n«baz»\n\n\n\n8").footnotes[0][1].should == "8"
        NudgeProgram.new("value «baz» \n«baz»      8").footnotes[0][1].should == "8"
        NudgeProgram.new("value «baz» \n«baz»8").footnotes[0][1].should == "8"
      end
      
      it "should should ignore trailing whitespace" do
        NudgeProgram.new("value «foo» \n«foo» 9\t\t").footnotes[0][1].should == "9"
        NudgeProgram.new("value «foo» \n«foo» 9\n\n\n\n").footnotes[0][1].should == "9"
        NudgeProgram.new("value «foo» \n«foo» 9     ").footnotes[0][1].should == "9"
      end
      
      it "should capture whitespace inside values" do
        NudgeProgram.new("value «bar» \n«bar» 9\t\t9").footnotes[0][1].should == "9\t\t9"
        NudgeProgram.new("value «bar» \n«bar» 9\n\n\n\n9").footnotes[0][1].should == "9\n\n\n\n9"
        NudgeProgram.new("value «bar» \n«bar» 9     9").footnotes[0][1].should == "9     9"
      end
      
      it "should trim whitespace between footnotes" do
        NudgeProgram.new("value «bar» \n«bar» 9\n  \n\t\n«baz»9").footnotes.length.should == 2
      end
    end
  end
  
  
  describe "code_section methods" do
    it "should have a #parses? method that returns true iff the code_section is valid" do
      NudgeProgram.new("do int_add").parses?.should == true
      NudgeProgram.new("block {}").parses?.should == true
      NudgeProgram.new("dofoo baz doo runrun").parses?.should == false
      NudgeProgram.new("").parses?.should == false
      
      NudgeProgram.new("value «bar» \n«bar» 9     9").parses?.should == true
      NudgeProgram.new("block {} «bar» 9     9").parses?.should == false
    end
    
    describe "should have a #tidy attribute with the indented, one-point per line structure" do
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
    end
  end
  
  
  describe "handling malformed programs" do
    it "should interpret an empty string as no code at all" do
      huh = NudgeProgram.new("")
      huh.code_section.should == ""
      huh.footnote_section.should == ""
      huh.footnotes.should == []
    end
    
    it "should interpret an unparseable codesection as no code at all, but keep footnotes"
    
    
    it "should read values linking to missing footnotes as linked to 'nil'"
    
    it "should collect unused footnotes" do
      hmm = NudgeProgram.new("do int_add\n«nob» nothing")
      hmm.footnotes.should include(["nob", "nothing"])
    end
    
    it "should only use the last occurrence of a footnote number, if duplicated"
    it "should act as specified above for unparseable programs with footnotes"
    it "should act as specified above when one or more footnote is unparseable"
  end
  
  
  
  describe "keep footnote values associated with proper program point Nodes" do
    it "should set the #value attribute of a ValueProgramPoint"
    
    it "should map values correctly based on the type strings"
    
    it "should create 'empty' values if it runs out of footnotes"
    
    it "should throw away unused footnotes"
    
    it "should associate values in the order they appear"
  end
end

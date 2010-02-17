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
    
    describe "capturing the footnotes" do
      it "should capture the footnote code into #footnote_section" do
        NudgeProgram.new("do int_add").footnote_section.should == ""
        NudgeProgram.new("block {}\n\n").footnote_section.should == ""
        
        NudgeProgram.new("value «int» \n«int» 8").footnote_section.should == "«int» 8"
        NudgeProgram.new("value «int» \n«int» 8 \n«code» value «bool»").footnote_section.should ==
          "«int» 8 \n«code» value «bool»"
      end
      
      it "should capture each individual footnote into #footnotes" do
        NudgeProgram.new("do int_add").footnotes.should == []
        NudgeProgram.new("value «int» \n«int» 8").footnotes.should include(["int"," 8"])
        
        tricky = NudgeProgram.new("value «int» \n«int» 8 \n«code» value «bool»").footnotes
        tricky.length.should == 2
        tricky[1][1].should == " value «bool»"
      end
    end
    
  end
  
  
  describe "keep footnote values associated with proper program point Nodes" do
    it "should set the #value attribute of a ValueProgramPoint" do
      bo = NudgeProgram.new("value «int» \n«int» 99")
      fn = bo.footnotes
      fn.length.should == 1
      bo.my_parser.should_not == nil
      $GIANT_GLOBAL_KLUDGE.should == fn
      wtf = bo.parse!
      puts wtf.associated_value.inspect
    end
    
    it "should map values correctly based on the type strings"
    
    it "should create 'empty' values if it runs out of footnotes"
    
    it "should throw away unused footnotes"
    
    it "should associate values in the order they appear"
  end
  
  describe "handling malformed programs" do
    it "should interpret an empty string as no code at all" do
      huh = NudgeProgram.new(" \n")
      huh.code_section.should == ""
      huh.footnote_section.should == ""
      huh.footnotes.should == []
    end
    
    it "should read values linking to missing footnotes as linked to 'nil'"
    it "should collect unused footnotes"
    it "should only use the last occurrence of a footnote number, if duplicated"
    it "should act as specified above for unparseable programs with footnotes"
    it "should act as specified above when one or more footnote is unparseable"
  end
  
  
  describe "handling whitespace" do
    it "should ignore leading whitespace"
    it "should should ignore trailing whitespace"
    it "should ignore newlines"
    it "should ignore space around footnote markup"
    it "should capture whitespace inside values"
    it "should remove extra whitespace before and after values in footnotes"
  end
  
  
  describe "building parsed ProgramPoint trees" do
    describe "single lines" do
      describe "should build ProgramPoints of the right subclass" do
        it "should read 'block {}' as a CodeBlockProgramPoint"
        it "should read 'ref x1' as a ChannelProgramPoint"
        it "should read 'value «71»' as a ValueProgramPoint"
        it "should read 'do int_add' as an InstructionProgramPoint"
      end
    end
    
    
    describe "nested blocks" do
      it "should read 'block {}' and produce a CodeblockProgramPoint with an empty #contents list"
      it "should read 'ref x1' and produce a ChannelPoint with no #contents method"
      it "should read 'block {ref x1}' as a CodeBlockPoint a 1-element #contents"
    end
    
  end
end

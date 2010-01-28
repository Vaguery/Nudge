#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('codeblock')
include Nudge

describe "Nudge Program Parsing" do
  before(:each) do
    @parser = NudgeCodeblockParser.new()
  end
  
  describe "parser should first break up programs into codeblock and footnotes" do
    describe "separating out the codeblock" do
      it "should read the codeblock into #raw_code"
    end
    
    describe "capturing the footnotes" do
      it "should capture all the footnotes into #footnotes"
      it "should capture the raw_code representing each footnote's value"
    end
    
    it "should result in a NudgeProgram object"
  end
  
  describe "handling malformed programs" do
    it "should interpret an empty string as no code at all"
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
        it "should read 'block {}' as a CodeBlockPoint"
        it "should read 'ref x1' as a ChannelPoint"
        it "should read 'value «71»' as a ValuePoint"
        it "should read 'do int_add' as an InstructionPoint"
      end
    end
    
    
    describe "nested blocks" do
      it "should read 'block {}' and produce a CodeBlockPoint with an empty #contents list"
      it "should read 'ref x1' and produce a ChannelPoint with no #contents method"
      it "should read 'block {ref x1}' as a CodeBlockPoint a 1-element #contents"
    end
    
    
    describe "multiline blocks" do
      it "should read 'block {ref x1 ref y1}' as a CodeBlockPoint a 2-element #contents"
    end
  end
end

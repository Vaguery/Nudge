#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('codeblock')
include Nudge

describe NudgeCodeblockParser do
  before(:each) do
    @parser = NudgeCodeblockParser.new()
  end
  
  it { should treetop_parse("value «int»") }
  it { should treetop_parse("do int_add") }
  it { should treetop_parse("ref x88") }
  
  it { should treetop_parse("block {}") }
  it { should treetop_parse("block {  }") }
  it { should treetop_parse("block {\n }") }
  it { should treetop_parse("block { block { block {block{block{}}}} }") }
  it { should treetop_parse("block {do int_add}") }
  it { should treetop_parse("block{do int_add}") }
  it { should treetop_parse("block{do int_add\ndo int_add value «foo»}") }
  
  
  it { should_not treetop_parse("value int (1)\ndo int_add") }
  it { should_not treetop_parse(" ") }
  it { should_not treetop_parse("block") }
  it { should_not treetop_parse("block ") }
  
  describe "captures" do
    it "should capture the contents" do
      @parsed = @parser.parse("block{do int_add\ndo int_subtract\nblock {}}")
      @parsed.contents.length.should == 3
      @parsed.contents[0].text_value.should include "do int_add"
      @parsed.contents[1].text_value.should include "do int_subtract"
      @parsed.contents[2].text_value.should include "block {}"
    end
  end
  
  
  describe "resulting node class" do
    it "should be a kind of CodeblockProgramPoint" do
      @parser.parse("block {}").should be_a_kind_of(CodeblockParseNode)
      @parser.parse("block{do int_add ref g44}").should be_a_kind_of(CodeblockParseNode)
      @parser.parse("do int_add").should_not be_a_kind_of(CodeblockParseNode)
    end
    
    it "should parse the contents" do
      parsed = @parser.parse("block{do int_add\nref t2\nblock {}\nvalue «tree»}")
      parsed.contents.length.should == 4
      parsed.contents[0].should be_a_kind_of(InstructionParseNode)
      parsed.contents[1].should be_a_kind_of(ReferenceParseNode)
      parsed.contents[2].should be_a_kind_of(CodeblockParseNode)
      parsed.contents[3].should be_a_kind_of(ValueParseNode)
      
      parsed.contents[2].contents.length.should == 0
    end
    
    it "should manage to collect empty contents for an empty block" do
      parsed = @parser.parse("block{}")
      parsed.contents.should == []
    end
  end
  
  describe "result should respond to #to_point correctly" do
    it "should return a CodeblockPoint instance when invoked" do
      cbp = @parser.parse('block {}').to_point
      cbp.should be_a_kind_of(CodeblockPoint)
      
      cb2 = @parser.parse('block { block {}}').to_point
      cb2.should be_a_kind_of(CodeblockPoint)
      cb2.contents.should be_a_kind_of(Array)
      cb2.contents[0].should be_a_kind_of(CodeblockPoint)
      
      bbb = @parser.parse('block { block { block {}}}').to_point
      bbb.should be_a_kind_of(CodeblockPoint)
      bbb.contents[0].should be_a_kind_of(CodeblockPoint)
      bbb.contents.length.should == 1
      bbb.contents[0].contents[0].should be_a_kind_of(CodeblockPoint)
    end
  end
  
  
end

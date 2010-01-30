#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('codeblock')
include Nudge

describe NudgeCodeblockParser do
  before(:each) do
    @parser = NudgeCodeblockParser.new()
  end
  
  it { should parse("value «int»") }
  it { should parse("do int_add") }
  it { should parse("ref x88") }
  
  it { should parse("block {}") }
  it { should parse("block {  }") }
  it { should parse("block {\n }") }
  it { should parse("block { block { block {block{block{}}}} }") }
  it { should parse("block {do int_add}") }
  it { should parse("block{do int_add}") }
  it { should parse("block{do int_add\ndo int_add value «foo»}") }
  
  
  it { should_not parse("value int (1)\ndo int_add") }
  it { should_not parse(" ") }
  it { should_not parse("block") }
  it { should_not parse("block ") }
  
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
      @parser.parse("block {}").should be_a_kind_of(CodeblockProgramPoint)
      @parser.parse("block{do int_add ref g44}").should be_a_kind_of(CodeblockProgramPoint)
      @parser.parse("do int_add").should_not be_a_kind_of(CodeblockProgramPoint)
    end
    
    it "should parse the contents" do
      parsed = @parser.parse("block{do int_add\nref t2\nblock {}\nvalue «tree»}")
      parsed.contents.length.should == 4
      parsed.contents[0].should be_a_kind_of(InstructionProgramPoint)
      parsed.contents[1].should be_a_kind_of(ReferenceProgramPoint)
      parsed.contents[2].should be_a_kind_of(CodeblockProgramPoint)
      parsed.contents[3].should be_a_kind_of(ValueProgramPoint)
      
      parsed.contents[2].contents.length.should == 0
      
    end
  end
  
end

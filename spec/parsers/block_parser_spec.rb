require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('codeblock')
include Nudge

describe NudgeCodeblockParser do
  before(:each) do
    @parser = NudgeCodeblockParser.new()
  end
  
  it { should parse("value (8)") }
  it { should parse("do int_add") }
  it { should parse("ref x88") }
  
  it { should parse("block {}") }
  it { should parse("block {  }") }
  it { should parse("block {\n }") }
  it { should parse("block { block { block {block{block{}}}} }") }
  it { should parse("block {do int_add}") }
  it { should parse("block{do int_add}") }
  it { should parse("block{do int_add\ndo int_add}") }
  
  
  it { should_not parse("value int (1)\ndo int_add") }
  it { should_not parse(" ") }
  it { should_not parse("block") }
  it { should_not parse("block ") }
end

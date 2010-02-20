# encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('value')
include Nudge

describe NudgeValueParser do
  before(:each) do
    @parser = NudgeValueParser.new()
  end
  
  it { should treetop_parse("value «float»") }
  it { should treetop_parse("value «bool_3»") }
  it { should treetop_parse("value  \n  «β_distribution»") }
  
  # deprecated syntax
  it { should_not treetop_parse('value «100»') }
  it { should_not treetop_parse('value float(2.1)') }
  it { should_not treetop_parse('value bool(false)') }
  it { should_not treetop_parse('value bool(false)') }
  
  
  describe "captures" do
    before(:each) do
      @parsed = @parser.parse("value «bool»")
    end
    
    it { should capture(:footnote_type).as('bool') }
  end
  
  
  describe "resulting node class" do
    it "should be a ValueProgramPoint" do
      parsed = @parser.parse("value «float»")
      parsed.should be_a_kind_of(ValueParseNode)
    end
    
    it "should capture the #type as a string" do
      parsed = @parser.parse("value «hi_there8»")
      parsed.type.should == 'hi_there8'
    end
    
    it "should have a #value attribute that's nil (at this point!)" do
      parsed = @parser.parse("value «jump»")      
    end
  end
  
  describe "result should respond to #to_point correctly" do
    it "should return a ValuePoint instance when invoked" do
      bp = @parser.parse('value «bool»').to_point
      bp.should be_a_kind_of(ValuePoint)
      bp.type.should == :bool
    end
  end
  
end

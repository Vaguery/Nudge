# encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('reference')
include Nudge

describe NudgeReferenceParser do
  before(:each) do
    @parser = NudgeReferenceParser.new()
  end
  
  it { should treetop_parse("ref x1") }
  it { should treetop_parse("ref h_factor_") }
  it { should treetop_parse("ref β2") }
  it { should treetop_parse("ref ǝ1qɐıɹɐʌ") }
  
  
  it { should_not treetop_parse("ref _x1") }
  it { should_not treetop_parse("ref 1x1") }
  it { should_not treetop_parse("ref 1 x 1") }
  
  
  describe "captures" do
    before(:each) do
      @parsed = @parser.parse("ref x_99_agent")
    end
    
    it { should capture(:vname).as('x_99_agent') }
  end
  
  describe "resulting node class" do
    it "should be a ReferenceProgramPoint" do
      parsed = @parser.parse("ref v23")
      parsed.should be_a_kind_of(ReferenceParseNode)
    end
    
    it "should capture the #variable_name as a string" do
      parsed = @parser.parse("ref β_23")
      parsed.variable_name.should == 'β_23'
    end
  end
  
  describe "result should respond to #to_point correctly" do
    it "should return a ReferencePoint instance when invoked" do
      rp = @parser.parse('ref guitar_shape').to_point
      rp.should be_a_kind_of(ReferencePoint)
      rp.name.should == "guitar_shape"
    end
  end
  
end
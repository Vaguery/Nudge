# encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('reference')
include Nudge

describe NudgeReferenceParser do
  before(:each) do
    @parser = NudgeReferenceParser.new()
  end
  
  it { should parse("ref x1") }
  it { should parse("ref h_factor_") }
  it { should parse("ref β2") }
  it { should parse("ref ǝ1qɐıɹɐʌ") }
  
  
  it { should_not parse("ref _x1") }
  it { should_not parse("ref 1x1") }
  it { should_not parse("ref 1 x 1") }
  
  
  describe "captures" do
    before(:each) do
      @parsed = @parser.parse("ref x_99_agent")
    end
    
    it { should capture(:vname).as('x_99_agent') }
  end
  
  describe "resulting node class" do
    it "should be a ReferenceProgramPoint" do
      parsed = @parser.parse("ref v23")
      parsed.should be_a_kind_of(ReferenceProgramPoint)
    end
    
    it "should capture the #variable_name as a string" do
      parsed = @parser.parse("ref β_23")
      parsed.variable_name.should == 'β_23'
    end
  end
end
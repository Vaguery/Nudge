# encoding: utf-8

require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('instruction')
include Nudge

describe NudgeInstructionParser do
  before(:each) do
    @parser = NudgeInstructionParser.new()
  end
  
  it { should parse("do int_add") }
  it { should parse("do anything") }
  it { should parse("do Int_ADD") }
  it { should parse("do β_assay") }
  
  it { should_not parse("do _int_add") }
  it { should_not parse("do 9int_add") }
  
  it { should_not parse("do is_real?") }
  it { should_not parse("do this_real!") }
  
  
  describe "captures" do
    before(:each) do
      @parsed = @parser.parse("do int_add")
    end
    
    it { should capture(:opcode).as('int_add') }
  end
  
  
  describe "resulting node class" do
    it "should be a InstructionProgramPoint" do
      parsed = @parser.parse("do anything")
      parsed.should be_a_kind_of(InstructionProgramPoint)
    end
    
    it "should capture the #instruction_name as a string" do
      parsed = @parser.parse("do β_assay")
      parsed.instruction_name.should == 'β_assay'
    end
  end
end

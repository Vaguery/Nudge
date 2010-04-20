#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe IntFromBoolInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = IntFromBoolInstruction.new(@context)
    @context.clear_stacks
  end
  
  it "should check that there are enough parameters" do
    @context.push(:bool, "false")
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    @context.clear_stacks # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should successfully run #go only if all preconditions are met" do
    @context.push(:bool, "false")
    @i1.should_receive(:cleanup)
    @i1.go
  end
  
  it "should create and push the new (expected) value to the right place" do
    @context.push(:bool, "false")
    @i1.go
    @context.depth(:int).should == 1
    @context.peek_value(:int).should == 0
    
    @context.push(:bool, "true")
    @i1.go
    @context.depth(:int).should == 2
    @context.peek_value(:int).should == 1
    
  end
end
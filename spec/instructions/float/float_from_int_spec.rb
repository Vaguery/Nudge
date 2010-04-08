#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe FloatFromIntInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatFromIntInstruction.new(@context)
    @context.clear_stacks
  end
  
  it "should check that there are enough parameters" do
    @context.push(:int, "12")
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    @context.clear_stacks # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should successfully run #go only if all preconditions are met" do
    @context.push(:int, "2")
    @i1.should_receive(:cleanup)
    @i1.go
  end
  
  it "should create and push the new (expected) value to the right place" do
    @context.push(:int, "-21")
    @i1.go
    @context.depth(:float).should == 1
    @context.peek_value(:float).should == -21.0
  end
end
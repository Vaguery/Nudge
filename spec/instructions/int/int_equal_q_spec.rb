#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe "IntEqualQInstruction" do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new    
    @i1 = IntEqualQInstruction.new(@context)
    @int1 = ValuePoint.new("int", 1)
    @int2 = ValuePoint.new("int", 2)
  end
  
  
  it "should check that there are enough parameters" do
    6.times {@context.stacks[:int].push(@int1)}
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    @context.clear_stacks # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should successfully run #go only if all preconditions are met" do
    5.times {@context.stacks[:int].push(@int1)}
    @i1.should_receive(:cleanup)
    @i1.go
  end
  
  it "should pop all the arguments" do
    @context.clear_stacks
    5.times {@context.stacks[:int].push(@int1)}
    @i1.stub!(:cleanup) # and do nothing
    @i1.go
    @context.stacks[:int].depth.should == 3
  end
  
  it "should push the result" do
    @context.clear_stacks
    @context.stacks[:int].push(@int1)
    @context.stacks[:int].push(@int1)
    @context.stacks[:int].push(@int1)
    @context.stacks[:int].push(@int2)
    @i1.go
    @context.stacks[:bool].peek.value.should == false
    @i1.go
    @context.stacks[:bool].peek.value.should == true
  end
end

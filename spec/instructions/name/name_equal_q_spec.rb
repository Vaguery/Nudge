#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe "NameEqualQInstruction" do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = NameEqualQInstruction.new(@context)
    @thing1 = ReferencePoint.new("x")
    @thing2 = ReferencePoint.new("x")
    @thing3 = ReferencePoint.new("not_x")
    @thing1.go(@context)
    @thing2.go(@context)
    @thing3.go(@context)
    @thing1.go(@context)
  end
  
  
  it "should check that there are enough parameters" do
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    @context.clear_stacks # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should push the correct result to the :bool stack" do
    @i1.go
    @context.stacks[:bool].peek.value.should == false
    @i1.go
    @context.stacks[:bool].peek.value.should == true
  end
end
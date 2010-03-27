#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe CodeEqualQInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeEqualQInstruction.new(@context)
  end
  
  
  it "should check that there are enough parameters" do
    thing1 = ValuePoint.new("code", "block {ref x}")
    @context.stacks[:code].push thing1
    @context.stacks[:code].push thing1
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    @context.clear_stacks # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should push the correct result to the :bool stack" do
    thing1 = ValuePoint.new("code", "ref x")
    thing2 = ValuePoint.new("code", "block {ref x}")
    @context.stacks[:code].push thing1
    @context.stacks[:code].push thing1
    @i1.go
    @context.stacks[:bool].peek.value.should == true
    
    @context.stacks[:code].push thing1
    @context.stacks[:code].push thing2
    @i1.go
    @context.stacks[:bool].peek.value.should == false
  end
  
  it "should not depend on the values, but the tidied program blueprints of the :code items" do
    thing1 = ValuePoint.new("code", "block { value «int» ref a}\n«int» 9182")
    thing2 = ValuePoint.new("code", "block {\nvalue   «int» ref \na  }\n«int»\t9182\n")
    @context.stacks[:code].push thing1
    @context.stacks[:code].push thing2
    @i1.go
    @context.stacks[:bool].peek.value.should == true
  end
end

#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe CodeFromNameInstruction do # needs unique specs because it's manipulating ReferencePoints
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeFromNameInstruction.new(@context)
    @context.clear_stacks
  end
  
  it "should check that there are enough parameters" do
    @context.stacks[:name].push(ReferencePoint.new("foo"))
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    @context.clear_stacks # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should successfully run #go only if all preconditions are met" do
    @context.stacks[:name].push(ReferencePoint.new("foo"))
    @i1.should_receive(:cleanup)
    @i1.go
  end
  
  it "should create and push the new (expected) value to the right place" do
    @context.stacks[:name].push(ReferencePoint.new("foo"))
    @i1.go
    @context.stacks[:name].depth.should == 0
    @context.stacks[:code].peek.value.should == "ref foo"
  end
end
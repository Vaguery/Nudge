#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecKInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecKInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = ExecKInstruction.new(@context)
      @context.reset("block { do int_add do int_subtract }")
      @context.step # unwrapping the two instructions
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least two items" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should delete the item from the second position on the :exec stack" do
        @context.stacks[:exec].depth.should == 2
        @i1.go
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].peek.tidy.should == "do int_add"
      end
    end
  end
end

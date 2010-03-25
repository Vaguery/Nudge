#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe BoolFlushInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = BoolFlushInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = BoolFlushInstruction.new(@context)
      @context.clear_stacks
      @bool1 = ValuePoint.new("bool", "true")
    end
    
    describe "\#preconditions?" do
      it "should check that the :bool stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should remove all items on the stack" do
        11.times {@context.stacks[:bool].push(@bool1)}
        @context.stacks[:bool].depth.should == 11
        @i1.go
        @context.stacks[:bool].depth.should == 0
      end
    end
  end
end

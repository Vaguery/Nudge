require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe IntFlushInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = IntFlushInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = IntFlushInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 1)
    end
    
    describe "\#preconditions?" do
      it "should check that the :int stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should remove all items on the stack" do
        11.times {@context.stacks[:int].push(@int1)}
        @context.stacks[:int].depth.should == 11
        @i1.go
        @context.stacks[:int].depth.should == 0
      end
    end
  end
end

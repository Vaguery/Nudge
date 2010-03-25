require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe IntDepthInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = IntDepthInstruction.new(@context)
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = IntDepthInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 1)
    end
    
    describe "\#preconditions?" do
      it "should check that the :int stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should count the items on the stack" do
        @i1.go
        @context.stacks[:int].peek.value.should == 0
        7.times {@context.stacks[:int].push @int1}
        @i1.go
        @context.stacks[:int].peek.value.should == 8
      end
    end
  end
end

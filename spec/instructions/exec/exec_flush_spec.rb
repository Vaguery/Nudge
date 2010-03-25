#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecFlushInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecFlushInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = ExecFlushInstruction.new(@context)
      @context.reset("block{value «bool» value «int» block {}}\n«bool»false\n«int»88")
    end
    
    describe "\#preconditions?" do
      it "should check that the :exec stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should remove all items on the :exec stack" do
        @context.step
        @context.stacks[:exec].depth.should == 3
        @i1.go
        @context.stacks[:exec].depth.should == 0
      end
    end
  end
end

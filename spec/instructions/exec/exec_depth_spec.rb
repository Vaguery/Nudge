#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecDepthInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecDepthInstruction.new(@context)
  end
  
  it "should have its context set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = ExecDepthInstruction.new(@context)
      @context.reset("block{value «bool» value «int» block {}}\n«bool»false\n«int»88")
    end
    
    describe "\#preconditions?" do
      it "should check that the :bool stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should count the items on the stack and push it onto the :int stack" do
        @context.stacks[:int].depth.should == 0
        @i1.go
        @context.stacks[:int].peek.value.should == 1
        @context.step # unpacking the three points onto :exec
        @i1.go
        @context.stacks[:int].peek.value.should == 3
      end
    end
  end
end

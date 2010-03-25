#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecPopInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecPopInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = ExecPopInstruction.new(@context)
      @context.reset("block {value «float»\nvalue «float»} \n«float» -2.1\n«float» -2.1")
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least one item" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should remove one item from the stack" do
        @context.step
        @context.stacks[:exec].depth.should == 2
        @i1.go
        @context.stacks[:exec].depth.should == 1
      end
    end
  end
end

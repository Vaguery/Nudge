#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe CodeNoopInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeNoopInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeNoopInstruction.new(@context)
    end

    describe "\#preconditions?" do
      it "should not need any items on any stacks" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should change nothing about the interpreter except the step count" do
        @context = Interpreter.new(program:"do code_noop")
        @context.enable(CodeNoopInstruction)
        earlier = @context.steps
        @context.run
        @context.steps.should == (earlier+1)
        @context.stacks.each {|k,v| v.depth.should == 0}
      end
    end
  end
end

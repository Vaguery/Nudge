#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecYInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecYInstruction.new(@context)
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
      @i1 = ExecYInstruction.new(@context)
      @context.reset("do int_add")
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least one item" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should end up with a block {do exec_y [something]} in the second position on the :exec stack" do
        @context.stacks[:exec].depth.should == 1
        @i1.go
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].peek.tidy.should == "do int_add"
        @context.stacks[:exec].entries[0].points.should == 3
        @context.stacks[:exec].entries[0].tidy.should include("do exec_y")
        @context.stacks[:exec].entries[0].tidy.should include(@context.stacks[:exec].peek.tidy)
      end
    end
  end
end

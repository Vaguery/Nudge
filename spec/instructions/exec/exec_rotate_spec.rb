#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecRotateInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecRotateInstruction.new(@context)
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
      @i1 = ExecRotateInstruction.new(@context)
      @context.reset("block{value «bool» value «int» value «float»}\n«bool» false\n«int»88\n«float»0.5")
      @context.step # [pushing the 3 points]
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least one item" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should rearrange the three items on the :exec stack" do
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [0.5, 88, false] # because the stacks are "backwards" in array form
        @i1.go
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [88, false, 0.5] # bottom one comes to top
      end
    end
  end
end

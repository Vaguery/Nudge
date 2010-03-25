#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecSwapInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecSwapInstruction.new(@context)
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
      @myInterpreter = Interpreter.new
      @i1 = ExecSwapInstruction.new(@myInterpreter)
      @myInterpreter.reset("block{value «bool»\n value «int»}\n«bool» false\n«int» 88")
      @myInterpreter.step # [pushing the two points]
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least one item" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should push a copy of the top item onto the :exec stack" do
        @myInterpreter.stacks[:exec].entries[0].value.should == 88
        @myInterpreter.stacks[:exec].entries[1].value.should == false
        @i1.go
        @myInterpreter.stacks[:exec].depth.should == 2
        @myInterpreter.stacks[:exec].entries[0].value.should == false
        @myInterpreter.stacks[:exec].entries[1].value.should == 88
      end
    end
  end
end

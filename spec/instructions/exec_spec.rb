require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe ExecPopInstruction do
  before(:each) do
    @i1 = ExecPopInstruction.instance
  end
  
  it "should be a singleton" do
    @i1.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      Stack.cleanup
      @i1 = ExecPopInstruction.instance
      @myInterpreter = Interpreter.new
      @myInterpreter.reset("block {literal float(-2.1)\nliteral float(-2.1)}")
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least item" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should remove one item from the stack" do
        @myInterpreter.step
        Stack.stacks[:exec].depth.should == 2
        @i1.go
        Stack.stacks[:exec].depth.should == 1
      end
    end
  end
end

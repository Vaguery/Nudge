#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecDuplicateInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecDuplicateInstruction.new(@context)
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
      @i1 = ExecDuplicateInstruction.new(@myInterpreter)
      @myInterpreter.reset("value «bool» \n«bool» false")
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least one item" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should push a copy of the top item onto the :exec stack" do
        @i1.go
        @myInterpreter.stacks[:exec].depth.should == 2
        @myInterpreter.stacks[:exec].entries[0].value.should == @myInterpreter.stacks[:exec].entries[1].value
      end
      
      it "should not be the same objectID, just in case" do
        @i1.go
        id1 = @myInterpreter.stacks[:exec].entries[0].object_id
        id2 = @myInterpreter.stacks[:exec].entries[1].object_id
        id1.should_not == id2
      end
    end
  end
end

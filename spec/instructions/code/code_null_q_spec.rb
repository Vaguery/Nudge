#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe CodeNullQInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeNullQInstruction.new(@context)
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
      @i1 = CodeNullQInstruction.new(@context)
    end

    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.stacks[:code].push(ValuePoint.new("code","block {}"))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should push a :bool that is false when the :code value isn't 'block {}'" do
        @context.stacks[:code].push(ValuePoint.new("code","ref x"))
        @i1.go
        @context.stacks[:bool].depth.should == 1
        @context.stacks[:bool].peek.value.should == false
      end
      
      it "should push a :bool that's true when the top :code item is 'block {}" do
        @context.stacks[:code].push(ValuePoint.new("code","block {}"))
        @i1.go
        @context.stacks[:bool].depth.should == 1
        @context.stacks[:bool].peek.value.should == true
      end
    end
  end
end

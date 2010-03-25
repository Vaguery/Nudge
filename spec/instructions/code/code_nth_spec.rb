#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeNthInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeNthInstruction.new(@context)
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeNthInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :int stack and :code stacks" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
      end
      
      it "should get the Nth item from the backbone of the top :code value" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref b"
      end
      
      it "should use the top :int modulo the length of the backbone" do
        @context.stacks[:int].push(ValuePoint.new("int", 11))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref c"        
      end
      
      it "should work for negative values too" do
        @context.stacks[:int].push(ValuePoint.new("int", -8172))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref a"
      end
      it "should return the top :code value itself if it's not a CodeblockPoint" do
        @context.stacks[:code].push(ValuePoint.new("code", "do int_rob"))
        @context.stacks[:int].push(ValuePoint.new("int", 21))
        @i1.go
        @context.stacks[:code].peek.value.should == "do int_rob"
        
      end
    end
  end
end

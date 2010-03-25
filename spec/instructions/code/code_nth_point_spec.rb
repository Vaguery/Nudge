#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeNthPointInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeNthPointInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeNthPointInstruction.new(@context)
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
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a block {ref b ref c}}"))
      end
      
      it "should get the Nth point of the top :code value" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref a\n  block {\n    ref b\n    ref c}}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a block {ref b ref c}}"))
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref a"
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a block {ref b ref c}}"))
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref b"
        
      end
      
      it "should use the top :int modulo the length of the backbone" do
        @context.stacks[:int].push(ValuePoint.new("int", 12))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref a"        
      end
      
      it "should work for negative values too" do
        @context.stacks[:int].push(ValuePoint.new("int", -6612))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref b\n  ref c}"
      end
    end
  end
end

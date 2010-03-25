#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe CodeNthCdrInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeNthCdrInstruction.new(@context)
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeNthCdrInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :code stack and one on :int" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should return the code item with the first n backbone items removed (if 0 < n < length)" do
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref c}"
        
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref b\n  ref c}"
      end
      
      it "should take n % length of code backbone for other integer values" do
        @context.stacks[:int].push(ValuePoint.new("int", 11)) # => 2
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref c}"
        
        @context.stacks[:int].push(ValuePoint.new("int", -921232)) # => 2
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref c}"
      end
      
      it "should return an empty codeblock unchanged" do
        @context.stacks[:int].push(ValuePoint.new("int", 11)) # => 2
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"
      end
      
      it "should wrap a non-codeblock point and just return it" do
        @context.stacks[:int].push(ValuePoint.new("int", 12))
        @context.stacks[:code].push(ValuePoint.new("code", "do x1"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do x1}"
      end
      
      it "should not remove anything if the int % length == 0" do
        @context.stacks[:int].push(ValuePoint.new("int", -921231)) # => 0
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref a\n  ref b\n  ref c}"
      end
    end
  end
end

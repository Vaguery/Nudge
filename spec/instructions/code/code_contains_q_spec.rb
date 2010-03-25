#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeContainsQInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeContainsQInstruction.new(@context)
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
      @i1 = CodeContainsQInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least two items on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should check to see if the second :code value is any point of the top item" do
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do int_multiply}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do something_else}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref x do int_multiply}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "block { block{ref x} block {do int_multiply}}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
      end
      
      it "should compare the two :code values for equality if the top one isn't a list" do
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
      end
      
      it "should return false if either item isn't parseable" do
        @context.stacks[:code].push(ValuePoint.new("code", "some crap"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "some other crap"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
      end
    end
  end
end

#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeMemberQInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeMemberQInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeMemberQInstruction.new(@context)
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
      it "should check to see if the second :code value is inside the [backbone of] the top item" do
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

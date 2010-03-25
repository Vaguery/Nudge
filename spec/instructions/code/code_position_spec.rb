#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge



describe CodePositionInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodePositionInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodePositionInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least two items on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "ref b"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a the point in the top item which has the same #listing as the second item" do
        @context.stacks[:code].push(ValuePoint.new("code", "do a"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do a do b}"))
        @i1.go
        @context.stacks[:int].peek.value.should == 2
        
        @context.stacks[:code].push(ValuePoint.new("code", "do a"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {block {do a}}"))
        @i1.go
        @context.stacks[:int].peek.value.should == 3
      end
      
      it "should return -1 if the string is not found" do
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do a do b}"))
        @i1.go
        @context.stacks[:int].peek.value.should == -1
      end
      
      it "should return 1 if they are the same" do
        @context.stacks[:code].push(ValuePoint.new("code", "do something"))
        @context.stacks[:code].push(ValuePoint.new("code", "do something"))
        @i1.go
        @context.stacks[:int].peek.value.should == 1
      end
      
      
      it "should return -1 if either arg is unparseable" do
        @context.stacks[:code].push(ValuePoint.new("code", "i got nuthin"))
        @context.stacks[:code].push(ValuePoint.new("code", "value «b»\n«b» 2"))
        @i1.go
        @context.stacks[:int].peek.value.should == -1
        
        @context.stacks[:code].push(ValuePoint.new("code", "value «b»\n«b» 2"))
        @context.stacks[:code].push(ValuePoint.new("code", "no idea"))
        @i1.go
        @context.stacks[:int].peek.value.should == -1
      end
    end
  end
end

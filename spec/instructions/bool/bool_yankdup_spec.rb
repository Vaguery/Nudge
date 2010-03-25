#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe BoolYankdupInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = BoolYankdupInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = BoolYankdupInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", "3")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :bool" do
        @context.stacks[:bool].push(ValuePoint.new("bool", "false"))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        (1..4).each {|i| @context.stacks[:bool].push(ValuePoint.new("bool",i.even?.to_s))}
      end
      
      it "should duplicate the top item if the position integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", "-99"))
        @i1.go
        and_now = @context.stacks[:bool].entries.collect {|i| i.value}
        and_now.should == [false, true, false, true, true]
      end
      
      it "should duplicate the top item if the position integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", "0"))
        @i1.go
        and_now = @context.stacks[:bool].entries.collect {|i| i.value}
        and_now.should == [false, true, false, true, true]
      end
      
      it "should clone the bottom item and push it if the position is more than the stackdepth" do
        @context.stacks[:int].push(ValuePoint.new("int", "1000"))
        @i1.go
        and_now = @context.stacks[:bool].entries.collect {|i| i.value}
        and_now.should == [false, true, false, true, false]
      end
      
      it "should push a copy of the indicated item to the top of the stack, counting from the 'top down'" do
        @context.stacks[:int].push(ValuePoint.new("int", "2"))
        @i1.go
        and_now = @context.stacks[:bool].entries.collect {|i| i.value}
        and_now.should == [false, true, false, true, true]
        
        @context.stacks[:int].push(ValuePoint.new("int", "2"))
        @i1.go
        and_now = @context.stacks[:bool].entries.collect {|i| i.value}
        and_now.should == [false, true, false, true, true, false]
      end
    end
  end
end

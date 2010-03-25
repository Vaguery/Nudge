#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe BoolShoveInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = BoolShoveInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = BoolShoveInstruction.new(@context)
      @context.clear_stacks
      @bool1 = ValuePoint.new("bool", "true")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :bool" do
        @context.stacks[:int].push(ValuePoint.new("int", "4"))
        @context.stacks[:bool].push(@bool1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        11.times {@context.stacks[:bool].push(@bool1)}
        @context.stacks[:bool].push(ValuePoint.new("bool", "false")) # making it 12 deep
      end
      
      it "should not move the top item if the integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", "-99"))
        @i1.go
        @context.stacks[:bool].depth.should == 12
        @context.stacks[:bool].peek.value.should == false
      end
      
      it "should not move the top item if the integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", "0"))
        @i1.go
        @context.stacks[:bool].depth.should == 12
        @context.stacks[:bool].peek.value.should == false  
      end
      
      it "should move the top item farther down if the value is less than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", "1000"))
        @i1.go
        @context.stacks[:bool].depth.should == 12
        @context.stacks[:bool].entries[0].value.should == false
      end
      
      it "should move the top item to the bottom if the value is more than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", "4"))
        @i1.go
        @context.stacks[:bool].depth.should == 12
        @context.stacks[:bool].entries[11].value.should == true
        @context.stacks[:bool].entries[7].value.should == false
      end
      
    end
  end
end

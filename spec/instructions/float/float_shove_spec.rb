require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe FloatShoveInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatShoveInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = FloatShoveInstruction.new(@context)
      @context.clear_stacks
      @float1 = ValuePoint.new("float", 9.9)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :float" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @context.stacks[:float].push(@float1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        11.times {@context.stacks[:float].push(@float1)}
        @context.stacks[:float].push(ValuePoint.new("float", 1.1)) # making it 12 deep
      end
      
      it "should not move the top item if the integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        @context.stacks[:float].depth.should == 12
        @context.stacks[:float].peek.value.should == 1.1
      end
      
      it "should not move the top item if the integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        @context.stacks[:float].depth.should == 12
        @context.stacks[:float].peek.value.should == 1.1
      end
      
      it "should move the top item farther down if the value is less than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        @context.stacks[:float].depth.should == 12
        @context.stacks[:float].entries[0].value.should == 1.1
      end
      
      it "should move the top item to the bottom if the value is more than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        @context.stacks[:float].depth.should == 12
        @context.stacks[:float].entries[11].value.should == 9.9
        @context.stacks[:float].entries[7].value.should == 1.1
      end
    end
  end
end

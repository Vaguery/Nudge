require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe IntShoveInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = IntShoveInstruction.new(@context)
  end
  
  it "should check its context is set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = IntShoveInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 77)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one more :int" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        11.times {@context.stacks[:int].push(@int1)}
        @context.stacks[:int].push(ValuePoint.new("int", 22)) # making it 12 deep
      end
      
      it "should not move the top item if the integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].peek.value.should == 22
      end
      
      it "should not move the top item if the integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].peek.value.should == 22  
      end
      
      it "should move the top item farther down if the value is less than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].entries[0].value.should == 22
      end
      
      it "should move the top item to the bottom if the value is more than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].entries[11].value.should == 77
        @context.stacks[:int].entries[7].value.should == 22
      end
    end
  end
end

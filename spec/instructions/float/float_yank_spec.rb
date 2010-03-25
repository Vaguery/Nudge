require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe FloatYankInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatYankInstruction.new(@context)
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
      @i1 = FloatYankInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 3)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :float and at least one :int" do
        @context.stacks[:float].push(ValuePoint.new("float", -99.99))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        (1..3).each {|i| @context.stacks[:float].push(ValuePoint.new("float",i*0.5))}
      end
      
      it "should not change anything if the position integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [0.5,1.0,1.5]
      end
      
      it "should not change anything if the position integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [0.5,1.0,1.5]
      end
      
      it "should pull the last item on the stack to the top if the position is more than the stackdepth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [1.0,1.5, 0.5]
      end
      
      it "should yank the indicated item to the top of the stack, counting from the 'top' 'down'" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [0.5,1.5, 1.0]
      end
    end
  end
end

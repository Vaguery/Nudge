require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe IntYankInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = IntYankInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = IntYankInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 3)
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
        (1..12).each {|i| @context.stacks[:int].push(ValuePoint.new("int",i))}
      end
      
      it "should not change anything if the position integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].peek.value.should == 12
      end
      
      it "should not change anything if the position integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].peek.value.should == 12  
      end
      
      it "should pull the last item on the stack to the top if the position is more than the stackdepth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        @context.stacks[:int].depth.should == 12
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [2,3,4,5,6,7,8,9,10,11,12,1]
      end
      
      it "should yank the indicated item to the top of the stack, counting from the 'top' 'down'" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        @context.stacks[:int].depth.should == 12
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5,6,7,9,10,11,12,8]
        # just to make sure
        @i1.go # uses '8' for depth
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [1,2,4,5,6,7,9,10,11,12,3]
        @i1.go # uses '3' for depth
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [1,2,4,5,6,7,10,11,12,9]
        
        # and so forth...
        
        8.times {@i1.go}
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [12,10]
        @i1.go
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [12]
        @i1.go
        and_now.should == [12]
      end
    end
  end
end

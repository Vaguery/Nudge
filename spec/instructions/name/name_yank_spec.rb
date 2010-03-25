require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe NameYankInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = NameYankInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = NameYankInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 3)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and at least one :int" do
        @context.stacks[:name].push(ReferencePoint.new("g"))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        ('d'..'f').each {|i| @context.stacks[:name].push(ReferencePoint.new(i))}
      end
      
      it "should not change anything if the position integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['d', 'e', 'f']
      end
      
      it "should not change anything if the position integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['d', 'e', 'f']
      end
      
      it "should pull the last item on the stack to the top if the position is more than the stackdepth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['e', 'f', 'd']
      end
      
      it "should yank the indicated item to the top of the stack, counting from the 'top' 'down'" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['d', 'f', 'e']
      end
    end
  end
end

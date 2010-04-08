require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe IntSwapInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = IntSwapInstruction.new(@context)
  end
  

  describe "\#go" do
    before(:each) do
      @i1 = IntSwapInstruction.new(@context)
      @int1 = ValuePoint.new("int", 88)
    end

    describe "\#preconditions?" do
      it "should check that there are enough parameters" do
        2.times {@context.stacks[:int].push(@int1)}
        @i1.preconditions?.should == true
      end
      
      it "should raise an error if the preconditions aren't met" do
        @context.clear_stacks # there are no params at all
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end
      
      it "should successfully run #go only if all preconditions are met" do
        3.times {@context.stacks[:int].push(@int1)}
        @i1.should_receive(:cleanup)
        @i1.go
      end
    end
    
    describe "\#derive" do
      it "should pop all the arguments" do
        2.times {@context.stacks[:int].push(@int1)}
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        @context.stacks[:int].depth.should == 0
      end
    end
    
    describe "\#cleanup" do
      it "should swap the top two values" do
        @context.push(:int,"1")
        @context.push(:int,"2")
        @i1.go
        @context.pop_value(:int).should == 1
        @context.pop_value(:int).should == 2
        
        @context.push(:int,"4444")
        @context.push(:int,"333")
        @i1.go
        @context.pop_value(:int).should == 4444
        @context.pop_value(:int).should == 333
      end
    end
  end
end

require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe IntDivideInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = IntDivideInstruction.new(@context)
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = IntDivideInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 1)
    end

    describe "\#preconditions?" do
      it "should check that there are enough parameters" do
        10.times {@context.stacks[:int].push(@int1)}
        @i1.preconditions?.should == true
      end
      
      it "should raise an error if the preconditions aren't met" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end
      
      it "should successfully run #go only if all preconditions are met" do
        5.times {@context.stacks[:int].push(@int1)}
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
      
      it "should raise the right exceptions if it tries to divide by zero" do
        @context.clear_stacks
        @context.stacks[:int].push(ValuePoint.new("int", 10))
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        @context.stacks[:error].depth.should == 1
      end
    end
    
    describe "\#cleanup" do
      describe "should push the result" do
        {[9,3] => 3, [3,9] => 0, [-9,-3] => 3}.each do |inputs, expected|
          params = inputs.inspect
          it "should produce #{expected} given #{params}" do
            inputs.each {|i| @context.stacks[:int].push(ValuePoint.new("int", i))}
            @i1.go
            @context.stacks[:int].peek.value.should == expected
          end
        end
      end
    end
  end
end

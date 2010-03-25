require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe FloatSineInstruction do

  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatSineInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = FloatSineInstruction.new(@context)
      @context.clear_stacks
      @float1 = ValuePoint.new("float", 12.12)
    end
  
    describe "\#preconditions?" do
      it "should check that there are enough parameters" do
        10.times {@context.stacks[:float].push(@float1)}
        @i1.preconditions?.should == true
      end
      
      it "should raise an error if the preconditions aren't met" do
        @context.clear_stacks # there are no params at all
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end
      
      it "should successfully run #go only if all preconditions are met" do
        5.times {@context.stacks[:float].push(@float1)}
        @i1.should_receive(:cleanup)
        @i1.go
      end
    end

    describe "\#derive" do
      it "should pop all the arguments" do
        @context.stacks[:float].push(@float1)
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        @context.stacks[:float].depth.should == 0
      end
    end
    
    describe "\#cleanup" do
      describe "should push the correct result" do
        {[3.0] => 0.141120008059867, [1.5707963267949] => 1.0, [0.0] => 0.0}.each do |inputs, expected|
          params = inputs.inspect
          it "should produce #{expected} given #{params}" do
            inputs.each {|i| @context.stacks[:float].push(ValuePoint.new("float", i))}
            @i1.go
            @context.peek_value(:float).should be_close(expected,0.000001)
          end
        end
      end
    end
  end
end

require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe FloatAddInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatAddInstruction.new(@context)
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = FloatAddInstruction.new(@context)
      @context.clear_stacks
      @float1 = ValuePoint.new("float", 12.12)
    end

    describe "\#preconditions?" do
      it "should check that there are enough parameters" do
        lambda{@i1.preconditions?}.should raise_error
        10.times {@context.stacks[:float].push(@float1)}
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#derive" do
      it "should pop all the arguments" do
        2.times {@context.stacks[:float].push(@float1)}
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        @context.stacks[:float].depth.should == 0
      end
    end
    
    describe "\#cleanup" do
      describe "should push the result" do
        {[1.0,3.0] => 4.0, [-3.1,4.2] => 1.1}.each do |inputs, expected|
          params = inputs.inspect
          it "should produce #{expected} given #{params}" do
          inputs.each {|i| @context.stacks[:float].push(ValuePoint.new("float", i))}
          @i1.go
          @context.stacks[:float].peek.value.should be_close(expected,0.000001)
        end
        end
      end
    end
  end
end

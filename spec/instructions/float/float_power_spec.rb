require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe FloatPowerInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatPowerInstruction.new(@context)
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = FloatPowerInstruction.new(@context)
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
        {[2.0,2.0] => 4.0, [8.0,0.3333333] => 2.0, [0.5,3.0] => 0.125}.each do |inputs, expected|
          params = inputs.inspect
          it "should produce #{expected} given #{params}" do
          inputs.each {|i| @context.stacks[:float].push(ValuePoint.new("float", i))}
          @i1.go
          @context.stacks[:float].peek.value.should be_close(expected,0.000001)
        end
        end
      end
    end
    
    it "should push an :error item when it takes a root of a neg" do
      context = Interpreter.new
      [-6.82,-0.2].each {|i| context.stacks[:float].push(ValuePoint.new("float", i))}
      lambda{FloatPowerInstruction.new(context).go}.should_not raise_error
      context.stacks[:error].peek.listing.should include("float_power did not return a float")
    end
    
  end
end

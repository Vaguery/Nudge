require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe ProportionBoundedAddInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = ProportionBoundedAddInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = ProportionBoundedAddInstruction.new(@context)
      @context.clear_stacks
      @p1 = ValuePoint.new("proportion", 0.2)
    end

    describe "\#preconditions?" do
      it "should check that there are enough parameters" do
        lambda{@i1.preconditions?}.should raise_error
        10.times {@context.stacks[:proportion].push(@p1)}
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#derive" do
      it "should pop all the arguments" do
        2.times {@context.stacks[:proportion].push(@p1)}
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        @context.stacks[:proportion].depth.should == 0
      end
    end
    
    describe "\#cleanup" do
      describe "should push the result" do
        {[0.1, 0.2] => 0.3, [0.5, 0.5] => 1.0, [0.8, 0.9] => 1.0}.each do |inputs, expected|
          params = inputs.inspect
          it "should produce #{expected} given #{params}" do
          inputs.each {|i| @context.stacks[:proportion].push(ValuePoint.new("proportion", i))}
          @i1.go
          @context.stacks[:proportion].peek.value.should be_close(expected,0.000001)
        end
        end
      end
    end
  end
end

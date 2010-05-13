require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ProportionBoundedDivideInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = ProportionBoundedDivideInstruction.new(@context)
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = ProportionBoundedDivideInstruction.new(@context)
      @context.clear_stacks
      @p1 = ValuePoint.new("proportion", 0.3)
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
      
      it "should push an error if it tries to divide by zero" do
        @context.clear_stacks
        @context.stacks[:proportion].push(ValuePoint.new("proportion", 0.9))
        @context.stacks[:proportion].push(ValuePoint.new("proportion", 0.0))
        @i1.go
        @context.stacks[:error].depth.should == 1
      end
    end
    
    describe "\#cleanup" do
      describe "should push the result" do
        {[0.3, 0.11] => 1.0, [0.3,0.8] => 0.375}.each do |inputs, expected|
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

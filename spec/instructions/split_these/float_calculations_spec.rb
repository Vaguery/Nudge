require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

theseInstructions = [
  FloatAddInstruction,
  FloatSubtractInstruction,
  FloatMultiplyInstruction,
  FloatDivideInstruction,
  FloatMaxInstruction,
  FloatMinInstruction,
  FloatAbsInstruction,
  FloatNegativeInstruction,
  FloatPowerInstruction,
  FloatSqrtInstruction,
  FloatModuloInstruction
  ]
  
floatsTheyNeed = {
  FloatAddInstruction => 2,
  FloatSubtractInstruction => 2,
  FloatMultiplyInstruction => 2,
  FloatDivideInstruction => 2,
  FloatMaxInstruction => 2,
  FloatMinInstruction => 2,
  FloatAbsInstruction => 1,
  FloatNegativeInstruction => 1,
  FloatPowerInstruction => 2,
  FloatSqrtInstruction => 1,
  FloatModuloInstruction => 2
  }
  
resultTuples = {
  FloatAddInstruction => {[1.0,3.0] => 4.0, [-3.1,4.2] => 1.1},
  FloatSubtractInstruction => {[12.2,12.2] => 0.0, [100.001,0.001] => 100.0},
  FloatMultiplyInstruction => {[-92.1,0.0] => 0.0, [-3.3,3.0] => -9.9},
  FloatDivideInstruction => {[3.3,1.1] => 3.0, [-10.0, 2.5] => -4.0},
  FloatMaxInstruction => {[7.7, 7.70001] => 7.70001, [-10.0, 2.5] => 2.5},
  FloatMinInstruction => {[2.99,2.990001] => 2.99, [-10.0, -9.0] => -10.0},
  FloatAbsInstruction => {[1.11] => 1.11, [-55.55] => 55.55},
  FloatPowerInstruction => {[2.0,2.0] => 4.0, [8.0,0.3333333] => 2.0, [0.5,3.0] => 0.125},
  FloatNegativeInstruction => {[4.44] => -4.44, [-91.1] => 91.1},
  FloatSqrtInstruction => {[4.0] => 2.0, [94.09] => 9.7},
  FloatModuloInstruction => {[1.1, 0.2] => 0.1, [-99.5 % 4.75] => 0.25, [-99.5 % -4.75] => -4.5}
  }
  
div0 = {
  FloatDivideInstruction => [8.12,0.0],
  FloatModuloInstruction => [12.12,0.0]
  }
  
    
theseInstructions.each do |instName|
  describe instName do
    before(:each) do
      @context = Interpreter.new
      @i1 = instName.new(@context)
    end
    
    it "should have the right context" do
      @i1.context.should == @context
    end
    
    [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
      it "should respond to \##{methodName}" do
        @i1 = instName.new(@context)
        @i1.should respond_to(methodName)
      end   
    end
    
    describe "\#go" do
      before(:each) do
        @i1 = instName.new(@context)
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
          reduction = floatsTheyNeed[instName]
          reduction.times {@context.stacks[:float].push(@float1)}
          @i1.stub!(:cleanup) # and do nothing
          @i1.go
          @context.stacks[:float].depth.should == 0
        end
        
        if div0.include? instName
          it "should push an error if it tries to divide by zero" do
            @context.clear_stacks
            @i1 = instName.new(@context)
            div0[instName].each {|i| @context.stacks[:float].push(ValuePoint.new("float", i))}
            @i1.go
            @context.stacks[:error].depth.should == 1
          end
        end
      end
      
      describe "\#cleanup" do
        describe "should push the result" do
          examples = resultTuples[instName]
          examples.each do |inputs, expected|
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
end

describe "FloatPowerInstruction" do
  it "should push an :error item when it takes a root of a neg" do
    context = Interpreter.new
    [-6.82,-0.2].each {|i| context.stacks[:float].push(ValuePoint.new("float", i))}
    lambda{FloatPowerInstruction.new(context).go}.should_not raise_error
    context.stacks[:error].peek.listing.should include("float_power did not return a float")
  end
end

describe "FloatSqrtInstruction" do
  it "should raise a NaNResultError when it takes a root of a neg" do
    context = Interpreter.new
    [-6.82, -16.0].each do |i|
      context.stacks[:float].push(ValuePoint.new("float", i))
      lambda{FloatSqrtInstruction.new(context).go}.should_not raise_error
      context.stacks[:error].peek.listing.should include("float_sqrt did not return a float")
    end
  end
end
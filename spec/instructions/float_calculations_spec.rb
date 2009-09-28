require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

theseInstructions = [
  FloatAddInstruction,
  FloatSubtractInstruction,
  FloatMultiplyInstruction,
  FloatDivideInstruction,
  FloatMaxInstruction
  ]
  
floatsTheyNeed = {
  FloatAddInstruction => 2,
  FloatSubtractInstruction => 2,
  FloatMultiplyInstruction => 2,
  FloatDivideInstruction => 2,
  FloatMaxInstruction => 2
  }
  
resultTuples = {
  FloatAddInstruction => {[1.0,3.0] => 4.0, [-3.1,4.2] => 1.1},
  FloatSubtractInstruction => {[12.2,12.2] => 0.0, [100.001,0.001] => 100.0},
  FloatMultiplyInstruction => {[-92.1,0.0] => 0.0, [-3.3,3.0] => -9.9},
  FloatDivideInstruction => {[3.3,1.1] => 3.0, [-10.0, 2.5] => -4.0},
  FloatMaxInstruction => {[7.7, 7.70001] => 7.70001, [-10.0, 2.5] => 2.5}
  }
  
div0 = {
  FloatDivideInstruction => [8.12,0.0]
  }
  
    
theseInstructions.each do |instName|
  describe instName do
    before(:each) do
      @i1 = instName.instance
    end
    
    it "should be a singleton" do
      @i1.should be_a_kind_of(Singleton)
    end
    
    [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
      it "should respond to \##{methodName}" do
        @i1 = instName.instance
        @i1.should respond_to(methodName)
      end   
    end
    
    describe "\#go" do
      before(:each) do
        @i1 = instName.instance
        Stack.cleanup
        @float1 = LiteralPoint.new("float", 12.12)
      end

      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          10.times {Stack.stacks[:float].push(@float1)}
          @i1.preconditions?.should == true
        end
        
        it "should raise an error if the preconditions aren't met" do
          Stack.cleanup # there are no params at all
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
        end
        
        it "should successfully run #go only if all preconditions are met" do
          5.times {Stack.stacks[:float].push(@float1)}
          @i1.should_receive(:cleanup)
          @i1.go
        end
      end
      
      describe "\#derive" do
        it "should pop all the arguments" do
          reduction = floatsTheyNeed[instName]
          reduction.times {Stack.stacks[:float].push(@float1)}
          @i1.stub!(:cleanup) # and do nothing
          @i1.go
          Stack.stacks[:float].depth.should == 0
        end
        
        if div0.include? instName
          it "should raise the right exceptions if it tries to divide by zero" do
            Stack.cleanup
            @i1 = instName.instance
            div0[instName].each {|i| Stack.stacks[:float].push(LiteralPoint.new("float", i))}
            @i1.setup
            lambda{@i1.derive}.should raise_error(Instruction::InstructionMethodError)
          end
        end
      end
      
      describe "\#cleanup" do
        describe "should push the result" do
          examples = resultTuples[instName]
          examples.each do |inputs, expected|
            params = inputs.inspect
            it "should produce #{expected} given #{params}" do
            inputs.each {|i| Stack.stacks[:float].push(LiteralPoint.new("float", i))}
            @i1.go
            Stack.stacks[:float].peek.value.should be_close(expected,0.000001)
          end
          end
        end
      end
    end
    
  end
end
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

theseInstructions = [
  FloatSineInstruction,
  FloatCosineInstruction,
  FloatTangentInstruction]
  
floatsTheyNeed = {
  FloatSineInstruction => 1,
  FloatCosineInstruction => 1,
  FloatTangentInstruction => 1}
  
resultTuples = {
  FloatSineInstruction => {[3.0] => 0.141120008059867, [1.5707963267949] => 1.0, [0.0] => 0.0},
  FloatCosineInstruction => {[0.0] => 1.0, [1.5707963267949] => 0.0, [-3.0] => -0.989992496600445},
  FloatTangentInstruction => {[0.0] => 0.0, [0.785398163397448] => 1.0, [-1.56079666010823] => -100.0}
  }


theseInstructions.each do |instName|
  describe instName do
    before(:each) do
      @context = Interpreter.new
      @i1 = instName.new(@context)
    end
    
    it "should have its context set correctly" do
      instName.new(@context).context.should == @context
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
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

theseInstructions = [
  BoolAndInstruction,
  BoolNotInstruction,
  BoolOrInstruction,
  BoolXorInstruction,
  BoolEqualQInstruction
  ]
  
boolsTheyNeed = {
  BoolAndInstruction => 2,
  BoolNotInstruction => 1,
  BoolOrInstruction => 2,
  BoolEqualQInstruction => 2,
  BoolXorInstruction => 2
  }
  
resultTuples = {
  BoolAndInstruction => {[true, true] => true, [true, false] => false, [false, false] => false},
  BoolNotInstruction => {[true] => false, [false] => true},
  BoolOrInstruction => {[true,true] => true, [true, false] => true, [false, false]=> false},
  BoolEqualQInstruction => {[true,true] => true, [true, false] => false, [false, false]=> true},
  BoolXorInstruction => {[true,true] => false, [true, false] => true, [false, true] => true, [false, false]=> false}
  }
  
  
  
theseInstructions.each do |instName|
  describe instName do
    before(:each) do
      @context = Interpreter.new
      @i1 = instName.new(@context)
    end
    
    it "should have its #context set to that Interpreter instance it's in" do
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
        @bool1 = ValuePoint.new("bool", false)
      end

      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          10.times {@context.stacks[:bool].push(@bool1)}
          @i1.preconditions?.should == true
        end
        
        it "should raise an error if the preconditions aren't met" do
          @context.clear_stacks # there are no params at all
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
        end
        
        it "should successfully run #go only if all preconditions are met" do
          5.times {@context.stacks[:bool].push(@bool1)}
          @i1.should_receive(:cleanup)
          @i1.go
        end
      end
      
      describe "\#derive" do
        it "should pop all the arguments" do
          reduction = boolsTheyNeed[instName]
          reduction.times {@context.stacks[:bool].push(@bool1)}
          @i1.stub!(:cleanup) # and do nothing
          @i1.go
          @context.stacks[:bool].depth.should == 0
        end
      end

      describe "\#cleanup" do
        describe "should push the result" do
          examples = resultTuples[instName]
          examples.each do |inputs, expected|
            params = inputs.inspect
            it "should produce #{expected} given #{params}" do
              inputs.each {|i| @context.stacks[:bool].push(ValuePoint.new("bool", i))}
              @i1.go
              @context.stacks[:bool].peek.value.should == expected
            end
          end
        end
      end
    end
  end
end
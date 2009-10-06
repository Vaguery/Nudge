require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

theseInstructions = [
  BoolAndInstruction
  ]
  
boolsTheyNeed = {
  BoolAndInstruction => 2
  }
  
resultTuples = {
  BoolAndInstruction => {[true, true] => true, [true, false] => false, [false, false] => false}
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
        @bool1 = LiteralPoint.new("bool", false)
      end

      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          10.times {Stack.stacks[:bool].push(@bool1)}
          @i1.preconditions?.should == true
        end
        
        it "should raise an error if the preconditions aren't met" do
          Stack.cleanup # there are no params at all
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
        end
        
        it "should successfully run #go only if all preconditions are met" do
          5.times {Stack.stacks[:bool].push(@bool1)}
          @i1.should_receive(:cleanup)
          @i1.go
        end
      end
      
      describe "\#derive" do
        it "should pop all the arguments" do
          reduction = boolsTheyNeed[instName]
          reduction.times {Stack.stacks[:bool].push(@bool1)}
          @i1.stub!(:cleanup) # and do nothing
          @i1.go
          Stack.stacks[:bool].depth.should == 0
        end
      end

      describe "\#cleanup" do
        describe "should push the result" do
          examples = resultTuples[instName]
          examples.each do |inputs, expected|
            params = inputs.inspect
            it "should produce #{expected} given #{params}" do
              inputs.each {|i| Stack.stacks[:bool].push(LiteralPoint.new("bool", i))}
              @i1.go
              Stack.stacks[:bool].peek.value.should == expected
            end
          end
        end
      end
    end
  end
end
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

theseInstructions = [
  IntIfInstruction,
  FloatIfInstruction
  ]
  
addressesStack = {
  IntIfInstruction => ["int", IntType],
  FloatIfInstruction => ["float", FloatType]
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
        @stackName = addressesStack[instName][0]
        @someValue = addressesStack[instName][1].any_value
        @myThing = LiteralPoint.new(@stackName,@someValue)
      end
    
      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          10.times {Stack.stacks[@stackName.to_sym].push(@myThing)}
          Stack.stacks[:bool].push(LiteralPoint.new("bool",true))
          @i1.preconditions?.should == true
        end
        
        it "should raise an error if the preconditions aren't met" do
          Stack.cleanup # there are no params at all
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
          Stack.stacks[:bool].push(LiteralPoint.new("bool",false))
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
          Stack.cleanup # there are no params at all
          Stack.stacks[@stackName.to_sym].push(@someValue)
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
        end
        
        it "should successfully run #go only if all preconditions are met" do
          5.times {Stack.stacks[@stackName.to_sym].push(@someValue)}
          Stack.stacks[:bool].push(LiteralPoint.new("bool",true))
          @i1.should_receive(:cleanup)
          @i1.go
        end
        
        describe "\#cleanup" do
          it "should only keep the value if :bool is true, delete if false" do
            Stack.cleanup
            Stack.stacks[@stackName.to_sym].push(@someValue)
            Stack.stacks[:bool].push(LiteralPoint.new("bool",false))
            @i1.go
            Stack.stacks[@stackName.to_sym].depth.should == 0
            Stack.stacks[@stackName.to_sym].push(@someValue)
            Stack.stacks[:bool].push(LiteralPoint.new("bool",true))
            @i1.go
            Stack.stacks[@stackName.to_sym].depth.should == 1
          end
        end
      end
    end
  end
end

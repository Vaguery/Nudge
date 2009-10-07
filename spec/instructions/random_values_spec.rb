require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge


theseInstructions = [
  IntRandomInstruction,
  BoolRandomInstruction,
  FloatRandomInstruction
  ]
  
whatItMakes = {
  IntRandomInstruction => {:where => :int, :what => IntType},
  BoolRandomInstruction => {:where => :bool, :what => BoolType},
  FloatRandomInstruction => {:where => :float, :what => FloatType}
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
        @stackName = whatItMakes[instName][:where]
      end
      
      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          # there are none, for these instructions
          @i1.preconditions?.should == true
        end
      end
        
      describe "\#cleanup" do
        it "should invoke Type#any_value" do
          Stack.cleanup
          whatItMakes[instName][:what].should_receive(:any_value)
          @i1.go
        end
        
        it "should have a created a new instance of the right type and pushed it" do
          Stack.cleanup
          @i1.go
          Stack.stacks[@stackName].depth.should == 1
          result = Stack.stacks[@stackName].peek
          result.value.should_not == nil
          result.type.should == @stackName
        end
      end
    end
  end
end

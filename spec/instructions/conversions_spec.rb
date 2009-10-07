require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

theseInstructions = [
  IntFromBoolInstruction,
  BoolFromIntInstruction,
  IntFromFloatInstruction,
  FloatFromIntInstruction,
  FloatFromBoolInstruction,
  BoolFromFloatInstruction
  ]

itNeeds = {
  IntFromBoolInstruction => {"stack" => :bool, "stackname" => "bool", "type" => BoolType, "becomes" => :int},
  IntFromFloatInstruction => {"stack" => :float, "stackname" => "float", "type" => FloatType, "becomes" => :int},
  BoolFromIntInstruction => {"stack" => :int, "stackname" => "int", "type" => IntType, "becomes" => :bool},
  BoolFromFloatInstruction => {"stack" => :float, "stackname" => "float", "type" => FloatType, "becomes" => :bool},
  FloatFromIntInstruction => {"stack" => :int, "stackname" => "int", "type" => IntType, "becomes" => :float},
  FloatFromBoolInstruction => {"stack" => :bool, "stackname" => "bool", "type" => BoolType, "becomes" => :float}
}
  
whatHappens = {
  IntFromBoolInstruction => {false => 0, true => 1},
  IntFromFloatInstruction => {1.1 => 1, -31.71 => -31},
  BoolFromIntInstruction => {0 => false, -2 => true, 122 => true},
  BoolFromFloatInstruction => {0.0 => false, -2.2 => true, 122.2 => true},
  FloatFromIntInstruction => {0 => 0.0, -2 => -2.0, 99 => 99.0},
  FloatFromBoolInstruction => {false => 0.0, true => 1.0}
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
        @stackSymbol = itNeeds[instName]["stack"]
        @stackName = itNeeds[instName]["stackname"]
        @someValue = itNeeds[instName]["type"].any_value
        @myStarter = LiteralPoint.new(@stackName,@someValue)
      end
      
      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          Stack.stacks[@stackSymbol].push(@myStarter)
          @i1.preconditions?.should == true
        end
        
        it "should raise an error if the preconditions aren't met" do
          Stack.cleanup # there are no params at all
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
        end
        
        it "should successfully run #go only if all preconditions are met" do
          Stack.stacks[@stackSymbol].push(@myStarter)
          @i1.should_receive(:cleanup)
          @i1.go
        end
        
        describe "\#cleanup" do
          describe "should create and push the new (expected) value to the right place" do
            before(:each) do
              Stack.cleanup
            end
            whatHappens[instName].each do |k,v|
              it "\'#{k}\' becomes #{itNeeds[instName]["becomes"]} \'#{v}\'" do
                Stack.stacks[@stackSymbol].push(LiteralPoint.new(@stackName,k))
              end
            end
          end
        end
      end
    end
  end
end
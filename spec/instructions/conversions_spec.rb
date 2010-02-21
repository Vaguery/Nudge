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
        @stackSymbol = itNeeds[instName]["stack"]
        @stackName = itNeeds[instName]["stackname"]
        @someValue = itNeeds[instName]["type"].any_value
        @myStarter = ValuePoint.new(@stackName,@someValue)
      end
      
      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          @context.stacks[@stackSymbol].push(@myStarter)
          @i1.preconditions?.should == true
        end
        
        it "should raise an error if the preconditions aren't met" do
          @context.clear_stacks # there are no params at all
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
        end
        
        it "should successfully run #go only if all preconditions are met" do
          @context.stacks[@stackSymbol].push(@myStarter)
          @i1.should_receive(:cleanup)
          @i1.go
        end
        
        describe "\#cleanup" do
          describe "should create and push the new (expected) value to the right place" do
            before(:each) do
              @context.clear_stacks
            end
            whatHappens[instName].each do |k,v|
              it "\'#{k}\' becomes #{itNeeds[instName]["becomes"]} \'#{v}\'" do
                @context.stacks[@stackSymbol].push(ValuePoint.new(@stackName,k))
              end
            end
          end
        end
      end
    end
  end
end
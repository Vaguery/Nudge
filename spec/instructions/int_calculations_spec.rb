require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

theseInstructions = [
  IntAddInstruction,
  IntMultiplyInstruction, 
  IntDivideInstruction, 
  IntSubtractInstruction, 
  IntModuloInstruction, 
  IntMaxInstruction, 
  IntMinInstruction, 
  IntAbsInstruction]
  
theyNeed = {
  IntAddInstruction => 2,
  IntMultiplyInstruction => 2, 
  IntDivideInstruction => 2, 
  IntSubtractInstruction => 2, 
  IntModuloInstruction => 2, 
  IntMaxInstruction => 2, 
  IntMinInstruction => 2, 
  IntAbsInstruction => 1}
  
resultTuples = {
  IntAddInstruction => {[1,3] => 4},
  IntMultiplyInstruction => {[-2,3] => -6}, 
  IntDivideInstruction => {[9,3] => 3, [3,9] => 0}, 
  IntSubtractInstruction => {[2,3] => -1}, 
  IntModuloInstruction => {[8,3] => 2}, 
  IntMaxInstruction => {[-2,-3] => -2}, 
  IntMinInstruction => {[-3,-2] => -3}, 
  IntAbsInstruction => {[-3] => 3} }
  
div0 = {
  IntDivideInstruction => [9,0], 
  IntModuloInstruction => [8,0]}
  
    
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
        @int1 = LiteralPoint.new("int", 1)
      end

      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          10.times {Stack.stacks[:int].push(@int1)}
          @i1.preconditions?.should == true
        end
        
        it "should raise an error if the preconditions aren't met" do
          Stack.cleanup # there are no params at all
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
        end
        
        it "should successfully run #go only if all preconditions are met" do
          5.times {Stack.stacks[:int].push(@int1)}
          @i1.should_receive(:cleanup)
          @i1.go
        end
      end
      
      describe "\#derive" do
        it "should pop all the arguments" do
          reduction = theyNeed[instName]
          reduction.times {Stack.stacks[:int].push(@int1)}
          @i1.stub!(:cleanup) # and do nothing
          @i1.go
          Stack.stacks[:int].depth.should == 0
        end
        
        if div0.include? instName
          it "should raise the right exceptions if it tries to divide by zero" do
            Stack.cleanup
            @i1 = instName.instance
            div0[instName].each {|i| Stack.stacks[:int].push(LiteralPoint.new("int", i))}
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
            inputs.each {|i| Stack.stacks[:int].push(LiteralPoint.new("int", i))}
            @i1.go
            Stack.stacks[:int].peek.value.should == expected
          end
          end
        end
      end
    end
    
  end
end
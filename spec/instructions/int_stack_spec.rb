require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

theseInstructions = [
  IntPopInstruction,
  IntSwapInstruction,
  IntDuplicateInstruction,
  IntRotateInstruction]
  
intsTheyNeed = {
  IntPopInstruction => 1,
  IntSwapInstruction => 2,
  IntDuplicateInstruction => 1,
  IntRotateInstruction => 3  }
  
resultTuples = {
  IntPopInstruction => {[1,2]=>[1]},
  IntSwapInstruction => {[1,2]=>[2,1]},
  IntDuplicateInstruction => {[33] => [33,33]},
  IntRotateInstruction => {[1,2,3] => [2,3,1]}  }
    
theseInstructions.each do |instName|
  describe instName do
    before(:each) do
      @context = Interpreter.new
      @i1 = instName.new(@context)
    end
    
    it "should have its context right" do
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
        @int1 = ValuePoint.new("int", 1)
      end
    
      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          10.times {@context.stacks[:int].push(@int1)}
          @i1.preconditions?.should == true
        end
        
        it "should raise an error if the preconditions aren't met" do
          @context.clear_stacks # there are no params at all
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
        end
        
        it "should successfully run #go only if all preconditions are met" do
          5.times {@context.stacks[:int].push(@int1)}
          @i1.should_receive(:cleanup)
          @i1.go
        end
      end
      
      describe "\#cleanup" do
        describe "should restructure the stack" do
          examples = resultTuples[instName]
          examples.each do |inputs, finalStackState|
            params = inputs.inspect
            expected = finalStackState.inspect
            it "should end up with #{expected} on the \:int stack, starting with #{params}" do
              inputs.each {|i| @context.stacks[:int].push(ValuePoint.new("int", i))}
              @i1.go
              finalStackState.reverse.each {|i| @context.stacks[:int].pop.value.should == i}
            end
          end
        end
      end
    end
  end
end
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

theseInstructions = [
  NamePopInstruction,
  NameSwapInstruction,
  NameDuplicateInstruction,
  NameRotateInstruction
  ]
  
namesTheyNeed = {
  NamePopInstruction => 1,
  NameSwapInstruction => 2,
  NameDuplicateInstruction => 1,
  NameRotateInstruction => 3
  }
  
resultTuples = {
  NamePopInstruction => {["a", "b"]=>["a"]},
  NameSwapInstruction => {["a", "b"]=>["b", "a"]},
  NameDuplicateInstruction => {["a"] => ["a", "a"]},
  NameRotateInstruction => {["a", "b", "c"] => ["b", "c", "a"]}
  }
    
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
        @name1 = ReferencePoint.new("a")
      end
    
      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          8.times {@context.stacks[:name].push(@name1)}
          @i1.preconditions?.should == true
        end
        
        it "should raise an error if the preconditions aren't met" do
          @context.clear_stacks # there are no params at all
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
        end
        
        it "should successfully run #go only if all preconditions are met" do
          7.times {@context.stacks[:name].push(@name1)}
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
            it "should end up with #{expected} on the \:name stack, starting with #{params}" do
              inputs.each {|i| @context.stacks[:name].push(ReferencePoint.new(i))}
              @i1.go
              finalStackState.reverse.each {|i| @context.stacks[:name].pop.value.should == i}
            end
          end
        end
      end
    end
  end
end
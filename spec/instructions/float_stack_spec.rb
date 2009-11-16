require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

theseInstructions = [
  FloatPopInstruction,
  FloatSwapInstruction,
  FloatDuplicateInstruction,
  FloatRotateInstruction
  ]
  
floatsTheyNeed = {
  FloatPopInstruction => 1,
  FloatSwapInstruction => 2,
  FloatDuplicateInstruction => 1,
  FloatRotateInstruction => 3
  }
  
resultTuples = {
  FloatPopInstruction => {[1.0,2.0]=>[1.0]},
  FloatSwapInstruction => {[1.1,2.2]=>[2.2,1.1]},
  FloatDuplicateInstruction => {[33.3] => [33.3,33.3]},
  FloatRotateInstruction => {[1.1,2.2,3.3] => [2.2,3.3,1.1]}
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
        @float1 = LiteralPoint.new("float", 1.0)
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
      
      describe "\#cleanup" do
        describe "should restructure the stack" do
          examples = resultTuples[instName]
          examples.each do |inputs, finalStackState|
            params = inputs.inspect
            expected = finalStackState.inspect
            it "should end up with #{expected} on the \:float stack, starting with #{params}" do
              inputs.each {|i| @context.stacks[:float].push(LiteralPoint.new("float", i))}
              @i1.go
              finalStackState.reverse.each {|i| @context.stacks[:float].pop.value.should == i}
            end
          end
        end
      end
    end
  end
end


describe FloatDepthInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = IntDepthInstruction.new(@context)
  end
  
  it "should have its context set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = FloatDepthInstruction.new(@context)
      @context.clear_stacks
      @float1 = LiteralPoint.new("float", 1)
    end
    
    describe "\#preconditions?" do
      it "should check that the :int stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should count the items on the stack and push it onto the :int stack" do
        @context.stacks[:int].depth.should == 0
        @i1.go # there are no floats
        @context.stacks[:int].peek.value.should == 0
        7.times {@context.stacks[:float].push @float1}
        @i1.go
        @context.stacks[:int].peek.value.should == 7
      end
    end
  end
end


describe FloatFlushInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatFlushInstruction.new(@context)
  end
  
  it "should behave its context set right" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = FloatFlushInstruction.new(@context)
      @context.clear_stacks
      @float1 = LiteralPoint.new("float", 1)
    end
    
    describe "\#preconditions?" do
      it "should check that the :int stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should remove all items on the stack" do
        11.times {@context.stacks[:float].push(@float1)}
        @context.stacks[:float].depth.should == 11
        @i1.go
        @context.stacks[:float].depth.should == 0
      end
    end
  end
end

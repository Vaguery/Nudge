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
        @float1 = ValuePoint.new("float", 1.0)
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
              inputs.each {|i| @context.stacks[:float].push(ValuePoint.new("float", i))}
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
    @i1 = FloatDepthInstruction.new(@context)
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
      @float1 = ValuePoint.new("float", 1)
    end
    
    describe "\#preconditions?" do
      it "should check that the :float stack responds to #depth" do
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
  
  it "should have its context set right" do
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
      @float1 = ValuePoint.new("float", 1)
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


describe FloatShoveInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatShoveInstruction.new(@context)
  end
  
  it "should check its context is set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = FloatShoveInstruction.new(@context)
      @context.clear_stacks
      @float1 = ValuePoint.new("float", 9.9)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :float" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @context.stacks[:float].push(@float1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        11.times {@context.stacks[:float].push(@float1)}
        @context.stacks[:float].push(ValuePoint.new("float", 1.1)) # making it 12 deep
      end
      
      it "should not move the top item if the integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        @context.stacks[:float].depth.should == 12
        @context.stacks[:float].peek.value.should == 1.1
      end
      
      it "should not move the top item if the integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        @context.stacks[:float].depth.should == 12
        @context.stacks[:float].peek.value.should == 1.1
      end
      
      it "should move the top item farther down if the value is less than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        @context.stacks[:float].depth.should == 12
        @context.stacks[:float].entries[0].value.should == 1.1
      end
      
      it "should move the top item to the bottom if the value is more than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        @context.stacks[:float].depth.should == 12
        @context.stacks[:float].entries[11].value.should == 9.9
        @context.stacks[:float].entries[7].value.should == 1.1
      end
    end
  end
end


describe FloatYankInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatYankInstruction.new(@context)
  end
  
  it "should check its context is set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = FloatYankInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 3)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :float and at least one :int" do
        @context.stacks[:float].push(ValuePoint.new("float", -99.99))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        (1..3).each {|i| @context.stacks[:float].push(ValuePoint.new("float",i*0.5))}
      end
      
      it "should not change anything if the position integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [0.5,1.0,1.5]
      end
      
      it "should not change anything if the position integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [0.5,1.0,1.5]
      end
      
      it "should pull the last item on the stack to the top if the position is more than the stackdepth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [1.0,1.5, 0.5]
      end
      
      it "should yank the indicated item to the top of the stack, counting from the 'top' 'down'" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [0.5,1.5, 1.0]
      end
    end
  end
end


describe FloatYankdupInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatYankdupInstruction.new(@context)
  end
  
  it "should check its context is set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = FloatYankdupInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 3)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :float" do
        @context.stacks[:float].push(ValuePoint.new("float", 1.1))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        (1..3).each {|i| @context.stacks[:float].push(ValuePoint.new("float",i*1.0))}
      end
      
      it "should duplicate the top item if the position integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [1.0,2.0,3.0, 3.0]
      end
      
      it "should duplicate the top item if the position integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [1.0,2.0,3.0, 3.0]
      end
      
      it "should clone the bottom item and push it if the position is more than the stackdepth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [1.0,2.0,3.0, 1.0]
      end
      
      it "should push a copy of the indicated item to the top of the stack, counting from the 'top down'" do
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [1.0,2.0,3.0, 1.0]
        
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @i1.go
        and_now = @context.stacks[:float].entries.collect {|i| i.value}
        and_now.should == [1.0,2.0,3.0, 1.0, 2.0]
      end
    end
  end
end

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


describe IntDepthInstruction do
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
      @i1 = IntDepthInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 1)
    end
    
    describe "\#preconditions?" do
      it "should check that the :int stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should count the items on the stack" do
        @i1.go
        @context.stacks[:int].peek.value.should == 0
        7.times {@context.stacks[:int].push @int1}
        @i1.go
        @context.stacks[:int].peek.value.should == 8
      end
    end
  end
end


describe IntFlushInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = IntFlushInstruction.new(@context)
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
      @i1 = IntFlushInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 1)
    end
    
    describe "\#preconditions?" do
      it "should check that the :int stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should remove all items on the stack" do
        11.times {@context.stacks[:int].push(@int1)}
        @context.stacks[:int].depth.should == 11
        @i1.go
        @context.stacks[:int].depth.should == 0
      end
    end
  end
end


describe IntShoveInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = IntShoveInstruction.new(@context)
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
      @i1 = IntShoveInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 77)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one more :int" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        11.times {@context.stacks[:int].push(@int1)}
        @context.stacks[:int].push(ValuePoint.new("int", 22)) # making it 12 deep
      end
      
      it "should not move the top item if the integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].peek.value.should == 22
      end
      
      it "should not move the top item if the integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].peek.value.should == 22  
      end
      
      it "should move the top item farther down if the value is less than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].entries[0].value.should == 22
      end
      
      it "should move the top item to the bottom if the value is more than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].entries[11].value.should == 77
        @context.stacks[:int].entries[7].value.should == 22
      end
    end
  end
end


describe IntYankInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = IntYankInstruction.new(@context)
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
      @i1 = IntYankInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 3)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one more :int" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        (1..12).each {|i| @context.stacks[:int].push(ValuePoint.new("int",i))}
      end
      
      it "should not change anything if the position integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].peek.value.should == 12
      end
      
      it "should not change anything if the position integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        @context.stacks[:int].depth.should == 12
        @context.stacks[:int].peek.value.should == 12  
      end
      
      it "should pull the last item on the stack to the top if the position is more than the stackdepth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        @context.stacks[:int].depth.should == 12
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [2,3,4,5,6,7,8,9,10,11,12,1]
      end
      
      it "should yank the indicated item to the top of the stack, counting from the 'top' 'down'" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        @context.stacks[:int].depth.should == 12
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5,6,7,9,10,11,12,8]
        # just to make sure
        @i1.go # uses '8' for depth
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [1,2,4,5,6,7,9,10,11,12,3]
        @i1.go # uses '3' for depth
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [1,2,4,5,6,7,10,11,12,9]
        
        # and so forth...
        
        8.times {@i1.go}
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [12,10]
        @i1.go
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [12]
        @i1.go
        and_now.should == [12]
      end
    end
  end
end


describe IntYankdupInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = IntYankdupInstruction.new(@context)
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
      @i1 = IntYankdupInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 3)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one more :int" do
        @context.stacks[:int].push(ValuePoint.new("int", 123))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        (1..5).each {|i| @context.stacks[:int].push(ValuePoint.new("int",i))}
      end
      
      it "should duplicate the top item if the position integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5,5]
      end
      
      it "should duplicate the top item if the position integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5,5]
      end
      
      it "should clone the bottom item and push it if the position is more than the stackdepth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5,1]
      end
      
      it "should push a copy of the indicated item to the top of the stack, counting from the 'top down'" do
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @i1.go
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5,3]
        
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @i1.go
        and_now = @context.stacks[:int].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5,3,4]
      end
    end
  end
end

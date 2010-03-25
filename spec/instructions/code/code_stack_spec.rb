require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

theseInstructions = [
  CodePopInstruction,
  CodeSwapInstruction,
  CodeDuplicateInstruction,
  CodeRotateInstruction
  ]
  
namesTheyNeed = {
  CodePopInstruction => 1,
  CodeSwapInstruction => 2,
  CodeDuplicateInstruction => 1,
  CodeRotateInstruction => 3
  }
  
resultTuples = {
  CodePopInstruction => {["block {}", "do int_add"]=>["block {}"]},
  CodeSwapInstruction => {["block {}", "do int_add"]=>["do int_add", "block {}"]},
  CodeDuplicateInstruction => {["block {}"] => ["block {}", "block {}"]},
  CodeRotateInstruction => {["block {}", "do int_add", "sample int(2)"] => ["do int_add", "sample int(2)", "block {}"]}
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
        @empty_block_code_value = ValuePoint.new("code", "block {}")
      end
    
      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          8.times {@context.stacks[:code].push(@empty_block_code_value)}
          @i1.preconditions?.should == true
        end
        
        it "should raise an error if the preconditions aren't met" do
          @context.clear_stacks # there are no params at all
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
        end
        
        it "should successfully run #go only if all preconditions are met" do
          7.times {@context.stacks[:code].push(@empty_block_code_value)}
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
            it "should end up with #{expected} on the \:code stack, starting with #{params}" do
              inputs.each {|i| @context.stacks[:code].push(ValuePoint.new("code",i))}
              @i1.go
              finalStackState.reverse.each {|i| @context.stacks[:code].pop.raw.should == i}
            end
          end
        end
      end
    end
  end
end


describe CodeDepthInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeDepthInstruction.new(@context)
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
      @i1 = CodeDepthInstruction.new(@context)
      @context.clear_stacks
      @empty_block_code_value = ValuePoint.new("code", "block {}")
    end
    
    describe "\#preconditions?" do
      it "should check that the :int stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should count the items on the stack and push it onto the :int stack" do
        @context.stacks[:int].depth.should == 0
        @i1.go # there are no code literals
        @context.stacks[:int].peek.value.should == 0
        7.times {@context.stacks[:code].push @empty_block_code_value}
        @i1.go
        @context.stacks[:int].peek.value.should == 7
      end
    end
  end
end


describe CodeFlushInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeFlushInstruction.new(@context)
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
      @i1 = CodeFlushInstruction.new(@context)
      @context.clear_stacks
      @empty_block_code_value = ValuePoint.new("code", "block {}")
    end
    
    describe "\#preconditions?" do
      it "should check that the :int stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should remove all items on the stack" do
        11.times {@context.stacks[:code].push(@empty_block_code_value)}
        @context.stacks[:code].depth.should == 11
        @i1.go
        @context.stacks[:code].depth.should == 0
      end
    end
  end
end


describe CodeShoveInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeShoveInstruction.new(@context)
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
      @i1 = CodeShoveInstruction.new(@context)
      @context.clear_stacks
      @empty_block_code_value = ValuePoint.new("code", "block {}")
      
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :code" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @context.stacks[:code].push(@empty_block_code_value)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        11.times {@context.stacks[:code].push(@empty_block_code_value)}
        @context.stacks[:code].push(ValuePoint.new("code","do int_add")) # making it 12 deep
      end
      
      it "should not move the top item if the integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        @context.stacks[:code].depth.should == 12
        @context.stacks[:code].peek.value.should == "do int_add"
      end
      
      it "should not move the top item if the integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        @context.stacks[:code].depth.should == 12
        @context.stacks[:code].peek.value.should == "do int_add"
      end
      
      it "should move the top item farther down if the value is less than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        @context.stacks[:code].depth.should == 12
        @context.stacks[:code].entries[0].value.should == "do int_add"
      end
      
      it "should move the top item to the bottom if the value is more than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        @context.stacks[:code].depth.should == 12
        @context.stacks[:code].entries[11].value.should == "block {}"
        @context.stacks[:code].entries[7].value.should == "do int_add"
      end
    end
  end
end


describe CodeYankInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeYankInstruction.new(@context)
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
      @i1 = CodeYankInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 3)
      @empty_block_code_value = ValuePoint.new("code", "block {}")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and at least one :int" do
        @context.stacks[:code].push(@empty_block_code_value)
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        (4..6).each {|i| @context.stacks[:code].push(ValuePoint.new("code","ref a_#{i}"))}
      end
      
      it "should not change anything if the position integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:code].entries.collect {|i| i.value}
        and_now.should == ["ref a_4", "ref a_5", "ref a_6"]
      end
      
      it "should not change anything if the position integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:code].entries.collect {|i| i.value}
        and_now.should == ["ref a_4", "ref a_5", "ref a_6"]
      end
      
      it "should pull the last item on the stack to the top if the position is more than the stackdepth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:code].entries.collect {|i| i.value}
        and_now.should == ["ref a_5", "ref a_6", "ref a_4"]
      end
      
      it "should yank the indicated item to the top of the stack, counting from the 'top' 'down'" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @i1.go
        and_now = @context.stacks[:code].entries.collect {|i| i.value}
        and_now.should == ["ref a_4", "ref a_6", "ref a_5"]
      end
    end
  end
end


describe CodeYankdupInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeYankdupInstruction.new(@context)
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
      @i1 = CodeYankdupInstruction.new(@context)
      @context.clear_stacks
      @int1 = ValuePoint.new("int", 3)
      @empty_block_code_value = ValuePoint.new("code", "block {}")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :code" do
        @context.stacks[:code].push(@empty_block_code_value)
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        (1..5).each {|i| @context.stacks[:code].push(ValuePoint.new("int", i))}
      end
      
      it "should duplicate the top item if the position integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:code].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5, 5]
      end
      
      it "should duplicate the top item if the position integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:code].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5, 5]
      end
      
      it "should clone the bottom item and push it if the position is more than the stackdepth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:code].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5, 1]
      end
      
      it "should push a copy of the indicated item to the top of the stack, counting from the 'top down'" do
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @i1.go
        and_now = @context.stacks[:code].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5, 3]
        
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        and_now = @context.stacks[:code].entries.collect {|i| i.value}
        and_now.should == [1,2,3,4,5, 3,2]
      end
    end
  end
end

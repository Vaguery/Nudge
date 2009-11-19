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
        @name1 = ChannelPoint.new("a")
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
              inputs.each {|i| @context.stacks[:name].push(ChannelPoint.new(i))}
              @i1.go
              finalStackState.reverse.each {|i| @context.stacks[:name].pop.value.should == i}
            end
          end
        end
      end
    end
  end
end


describe NameDepthInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameDepthInstruction.new(@context)
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
      @i1 = NameDepthInstruction.new(@context)
      @context.clear_stacks
      @name1 = ChannelPoint.new("d")
    end
    
    describe "\#preconditions?" do
      it "should check that the :float stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should count the items on the stack and push it onto the :int stack" do
        @context.stacks[:int].depth.should == 0
        @i1.go # there are no names
        @context.stacks[:int].peek.value.should == 0
        7.times {@context.stacks[:name].push @name1}
        @i1.go
        @context.stacks[:int].peek.value.should == 7
      end
    end
  end
end


describe NameFlushInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameFlushInstruction.new(@context)
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
      @i1 = NameFlushInstruction.new(@context)
      @context.clear_stacks
      @name1 = ChannelPoint.new("xx")
    end
    
    describe "\#preconditions?" do
      it "should check that the :int stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should remove all items on the stack" do
        11.times {@context.stacks[:name].push(@name1)}
        @context.stacks[:name].depth.should == 11
        @i1.go
        @context.stacks[:name].depth.should == 0
      end
    end
  end
end


describe NameShoveInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameShoveInstruction.new(@context)
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
      @i1 = NameShoveInstruction.new(@context)
      @context.clear_stacks
      @name1 = ChannelPoint.new("abc")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :name" do
        @context.stacks[:int].push(LiteralPoint.new("int", 4))
        @context.stacks[:name].push(@name1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        11.times {@context.stacks[:name].push(@name1)}
        @context.stacks[:name].push(ChannelPoint.new("xyz")) # making it 12 deep
      end
      
      it "should not move the top item if the integer is negative" do
        @context.stacks[:int].push(LiteralPoint.new("int", -99))
        @i1.go
        @context.stacks[:name].depth.should == 12
        @context.stacks[:name].peek.value.should == "xyz"
      end
      
      it "should not move the top item if the integer is zero" do
        @context.stacks[:int].push(LiteralPoint.new("int", 0))
        @i1.go
        @context.stacks[:name].depth.should == 12
        @context.stacks[:name].peek.value.should == "xyz"
      end
      
      it "should move the top item farther down if the value is less than the depth" do
        @context.stacks[:int].push(LiteralPoint.new("int", 1000))
        @i1.go
        @context.stacks[:name].depth.should == 12
        @context.stacks[:name].entries[0].value.should == "xyz"
      end
      
      it "should move the top item to the bottom if the value is more than the depth" do
        @context.stacks[:int].push(LiteralPoint.new("int", 4))
        @i1.go
        @context.stacks[:name].depth.should == 12
        @context.stacks[:name].entries[11].value.should == "abc"
        @context.stacks[:name].entries[7].value.should == "xyz"
      end
    end
  end
end


describe NameYankInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameYankInstruction.new(@context)
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
      @i1 = NameYankInstruction.new(@context)
      @context.clear_stacks
      @int1 = LiteralPoint.new("int", 3)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and at least one :int" do
        @context.stacks[:name].push(ChannelPoint.new("g"))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        ('d'..'f').each {|i| @context.stacks[:name].push(ChannelPoint.new(i))}
      end
      
      it "should not change anything if the position integer is negative" do
        @context.stacks[:int].push(LiteralPoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['d', 'e', 'f']
      end
      
      it "should not change anything if the position integer is zero" do
        @context.stacks[:int].push(LiteralPoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['d', 'e', 'f']
      end
      
      it "should pull the last item on the stack to the top if the position is more than the stackdepth" do
        @context.stacks[:int].push(LiteralPoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['e', 'f', 'd']
      end
      
      it "should yank the indicated item to the top of the stack, counting from the 'top' 'down'" do
        @context.stacks[:int].push(LiteralPoint.new("int", 1))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['d', 'f', 'e']
      end
    end
  end
end


describe NameYankdupInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameYankdupInstruction.new(@context)
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
      @i1 = NameYankdupInstruction.new(@context)
      @context.clear_stacks
      @int1 = LiteralPoint.new("int", 3)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :name" do
        @context.stacks[:name].push(ChannelPoint.new('x'))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        ('m'..'q').each {|i| @context.stacks[:name].push(ChannelPoint.new(i))}
      end
      
      it "should duplicate the top item if the position integer is negative" do
        @context.stacks[:int].push(LiteralPoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['m', 'n', 'o', 'p', 'q', 'q']
      end
      
      it "should duplicate the top item if the position integer is zero" do
        @context.stacks[:int].push(LiteralPoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['m', 'n', 'o', 'p', 'q', 'q']
      end
      
      it "should clone the bottom item and push it if the position is more than the stackdepth" do
        @context.stacks[:int].push(LiteralPoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['m', 'n', 'o', 'p', 'q', 'm']
      end
      
      it "should push a copy of the indicated item to the top of the stack, counting from the 'top down'" do
        @context.stacks[:int].push(LiteralPoint.new("int", 2))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['m', 'n', 'o', 'p', 'q', 'o']
        
        @context.stacks[:int].push(LiteralPoint.new("int", 4))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['m', 'n', 'o', 'p', 'q', 'o', 'n']
      end
    end
  end
end

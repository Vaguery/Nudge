require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


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
      @int1 = ValuePoint.new("int", 3)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :name" do
        @context.stacks[:name].push(ReferencePoint.new('x'))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        ('m'..'q').each {|i| @context.stacks[:name].push(ReferencePoint.new(i))}
      end
      
      it "should duplicate the top item if the position integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['m', 'n', 'o', 'p', 'q', 'q']
      end
      
      it "should duplicate the top item if the position integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['m', 'n', 'o', 'p', 'q', 'q']
      end
      
      it "should clone the bottom item and push it if the position is more than the stackdepth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['m', 'n', 'o', 'p', 'q', 'm']
      end
      
      it "should push a copy of the indicated item to the top of the stack, counting from the 'top down'" do
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['m', 'n', 'o', 'p', 'q', 'o']
        
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        and_now = @context.stacks[:name].entries.collect {|i| i.value}
        and_now.should == ['m', 'n', 'o', 'p', 'q', 'o', 'n']
      end
    end
  end
end

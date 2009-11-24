require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe IntIfInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = IntIfInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = IntIfInstruction.new(@context)
      @v1 = LiteralPoint.new("int",  1)
      @v2 = LiteralPoint.new("int", -100)
    end

    describe "\#preconditions?" do
      it "should check that there are two items on the target stack and at least one :bool" do
        @context.stacks[:int].push(@v1)
        @context.stacks[:int].push(@v2)
        @context.stacks[:bool].push(LiteralPoint.new("bool", true))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should keep the top :int if the :bool is true, otherwise the second" do
        @context.stacks[:int].push(@v1)
        @context.stacks[:int].push(@v2)
        @context.stacks[:bool].push(LiteralPoint.new("bool", true))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 1
        
        @context.stacks[:int].push(@v1)
        @context.stacks[:int].push(@v2)
        @context.stacks[:bool].push(LiteralPoint.new("bool", false))
        @i1.go
        @context.stacks[:int].peek.value.should == -100
      end
    end
  end
end


describe FloatIfInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatIfInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = FloatIfInstruction.new(@context)
      @v1 = LiteralPoint.new("float",  1.0)
      @v2 = LiteralPoint.new("float", -9.5)
    end

    describe "\#preconditions?" do
      it "should check that there are two items on the target stack and at least one :bool" do
        @context.stacks[:float].push(@v1)
        @context.stacks[:float].push(@v2)
        @context.stacks[:bool].push(LiteralPoint.new("bool", true))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should keep the top :int if the :bool is true, otherwise the second" do
        @context.stacks[:float].push(@v1)
        @context.stacks[:float].push(@v2)
        @context.stacks[:bool].push(LiteralPoint.new("bool", true))
        @i1.go
        @context.stacks[:float].depth.should == 1
        @context.stacks[:float].peek.value.should == 1.0
        
        @context.stacks[:float].push(@v1)
        @context.stacks[:float].push(@v2)
        @context.stacks[:bool].push(LiteralPoint.new("bool", false))
        @i1.go
        @context.stacks[:float].peek.value.should == -9.5
      end
    end
  end
end


describe ExecIfInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecIfInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @context.enable(ExecIfInstruction)
      @i1 = ExecIfInstruction.new(@context)
      @v1 = LiteralPoint.new("float",  1.0)
      @v2 = LiteralPoint.new("float", -9.5)
    end

    describe "\#preconditions?" do
      it "should check that there are two items on the target stack and at least one :bool" do
        @context.stacks[:exec].push(@v1)
        @context.stacks[:exec].push(@v2)
        @context.stacks[:bool].push(LiteralPoint.new("bool", true))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should keep the top :exec item if the :bool is true, otherwise the second" do
        @context.stacks[:exec].push(@v1)
        @context.stacks[:exec].push(@v2)
        @context.stacks[:bool].push(LiteralPoint.new("bool", true))
        @i1.go
        @context.stacks[:exec].entries.each {|i| p i.listing}
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].peek.value.should == 1.0
        
        @context.stacks[:exec].push(@v1)
        @context.stacks[:exec].push(@v2)
        @context.stacks[:bool].push(LiteralPoint.new("bool", false))
        @i1.go
        @context.stacks[:exec].peek.value.should == -9.5
      end
    end
  end
end

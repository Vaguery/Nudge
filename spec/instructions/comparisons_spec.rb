require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "IntEqualQInstruction" do
  before(:each) do
    @context = Interpreter.new    
    @i1 = IntEqualQInstruction.new(@context)
    @int1 = LiteralPoint.new("int", 1)
    @int2 = LiteralPoint.new("int", 2)
  end
  
  it "should have its #context set to that Interpreter instance it's in" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end 
  
  it "should check that there are enough parameters" do
    6.times {@context.stacks[:int].push(@int1)}
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
  
  it "should pop all the arguments" do
    @context.clear_stacks
    5.times {@context.stacks[:int].push(@int1)}
    @i1.stub!(:cleanup) # and do nothing
    @i1.go
    @context.stacks[:int].depth.should == 3
  end
  
  it "should push the result" do
    @context.clear_stacks
    @context.stacks[:int].push(@int1)
    @context.stacks[:int].push(@int1)
    @context.stacks[:int].push(@int1)
    @context.stacks[:int].push(@int2)
    @i1.go
    @context.stacks[:bool].peek.value.should == false
    @i1.go
    @context.stacks[:bool].peek.value.should == true
  end
end


describe "IntLessThanQInstruction" do
  before(:each) do
    @context = Interpreter.new    
    @i1 = IntLessThanQInstruction.new(@context)
    @int1 = LiteralPoint.new("int", 1)
    @int2 = LiteralPoint.new("int", 2)
  end
  
  it "should have a #context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end 
  
  it "should check that there are enough parameters" do
    6.times {@context.stacks[:int].push(@int1)}
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
  
  it "should pop all the arguments" do
    @context.clear_stacks
    5.times {@context.stacks[:int].push(@int1)}
    @i1.stub!(:cleanup) # and do nothing
    @i1.go
    @context.stacks[:int].depth.should == 3
  end
  
  it "should push the result" do
    @context.clear_stacks
    @context.stacks[:int].push(@int1)
    @context.stacks[:int].push(@int1)
    @i1.go
    @context.stacks[:bool].peek.value.should == false
    
    @context.stacks[:int].push(@int1)
    @context.stacks[:int].push(@int2)
    @i1.go
    @context.stacks[:bool].peek.value.should == true
    
    @context.stacks[:int].push(@int2)
    @context.stacks[:int].push(@int1)
    @i1.go
    @context.stacks[:bool].peek.value.should == false
  end
end


describe "IntGreaterThanQInstruction" do
  before(:each) do
    @context = Interpreter.new
    @i1 = IntGreaterThanQInstruction.new(@context)
    @int1 = LiteralPoint.new("int", 1)
    @int2 = LiteralPoint.new("int", 2)
  end
  
  it "should have its #context set correctly" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end 
  
  it "should check that there are enough parameters" do
    6.times {@context.stacks[:int].push(@int1)}
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
  
  it "should pop all the arguments" do
    @context.clear_stacks
    5.times {@context.stacks[:int].push(@int1)}
    @i1.stub!(:cleanup) # and do nothing
    @i1.go
    @context.stacks[:int].depth.should == 3
  end
  
  it "should push the result" do
    @context.clear_stacks
    @context.stacks[:int].push(@int1)
    @context.stacks[:int].push(@int1)
    @i1.go
    @context.stacks[:bool].peek.value.should == false
    
    @context.stacks[:int].push(@int1)
    @context.stacks[:int].push(@int2)
    @i1.go
    @context.stacks[:bool].peek.value.should == false
    
    @context.stacks[:int].push(@int2)
    @context.stacks[:int].push(@int1)
    @i1.go
    @context.stacks[:bool].peek.value.should == true
  end
end


describe "FloatGreaterThanQInstruction" do
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatGreaterThanQInstruction.new(@context)
    @float1 = LiteralPoint.new("float", 1.0)
    @float2 = LiteralPoint.new("float", 2.0)
  end
  
  it "should have its context set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end 
  
  it "should check that there are enough parameters" do
    6.times {@context.stacks[:float].push(@float1)}
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
  
  it "should pop all the arguments" do
    @context.clear_stacks
    5.times {@context.stacks[:float].push(@float1)}
    @i1.stub!(:cleanup) # and do nothing
    @i1.go
    @context.stacks[:float].depth.should == 3
  end
  
  it "should push the result" do
    @context.clear_stacks
    @context.stacks[:float].push(@float1)
    @context.stacks[:float].push(@float1)
    @i1.go
    @context.stacks[:bool].peek.value.should == false
    
    @context.stacks[:float].push(@float1)
    @context.stacks[:float].push(@float2)
    @i1.go
    @context.stacks[:bool].peek.value.should == false
    
    @context.stacks[:float].push(@float2)
    @context.stacks[:float].push(@float1)
    @i1.go
    @context.stacks[:bool].peek.value.should == true
  end
end


describe "FloatLessThanQInstruction" do
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatLessThanQInstruction.new(@context)
    @float1 = LiteralPoint.new("float", 1.0)
    @float2 = LiteralPoint.new("float", 2.0)
  end
  
  it "should have its context set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end 
  
  it "should check that there are enough parameters" do
    6.times {@context.stacks[:float].push(@float1)}
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
  
  it "should pop all the arguments" do
    @context.clear_stacks
    5.times {@context.stacks[:float].push(@float1)}
    @i1.stub!(:cleanup) # and do nothing
    @i1.go
    @context.stacks[:float].depth.should == 3
  end
  
  it "should push the result" do
    @context.clear_stacks
    @context.stacks[:float].push(@float1)
    @context.stacks[:float].push(@float1)
    @i1.go
    @context.stacks[:bool].pop.value.should == false
    
    @context.stacks[:float].push(@float1)
    @context.stacks[:float].push(@float2)
    @i1.go
    @context.stacks[:bool].pop.value.should == true
    
    @context.stacks[:float].push(@float2)
    @context.stacks[:float].push(@float1)
    @i1.go
    @context.stacks[:bool].pop.value.should == false
  end
end
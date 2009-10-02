require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "IntEqualQInstruction" do
  before(:each) do
    @i1 = IntEqualQInstruction.instance
    @int1 = LiteralPoint.new("int", 1)
    @int2 = LiteralPoint.new("int", 2)
  end
  
  it "should be a singleton" do
    @i1.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end 
  
  it "should check that there are enough parameters" do
    6.times {Stack.stacks[:int].push(@int1)}
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    Stack.cleanup # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should successfully run #go only if all preconditions are met" do
    5.times {Stack.stacks[:int].push(@int1)}
    @i1.should_receive(:cleanup)
    @i1.go
  end
  
  it "should pop all the arguments" do
    Stack.cleanup
    5.times {Stack.stacks[:int].push(@int1)}
    @i1.stub!(:cleanup) # and do nothing
    @i1.go
    Stack.stacks[:int].depth.should == 3
  end
  
  it "should push the result" do
    Stack.cleanup
    Stack.stacks[:int].push(@int1)
    Stack.stacks[:int].push(@int1)
    Stack.stacks[:int].push(@int1)
    Stack.stacks[:int].push(@int2)
    @i1.go
    Stack.stacks[:bool].peek.value.should == false
    @i1.go
    Stack.stacks[:bool].peek.value.should == true
  end
end


describe "IntLessThanQInstruction" do
  before(:each) do
    @i1 = IntLessThanQInstruction.instance
    @int1 = LiteralPoint.new("int", 1)
    @int2 = LiteralPoint.new("int", 2)
  end
  
  it "should be a singleton" do
    @i1.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end 
  
  it "should check that there are enough parameters" do
    6.times {Stack.stacks[:int].push(@int1)}
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    Stack.cleanup # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should successfully run #go only if all preconditions are met" do
    5.times {Stack.stacks[:int].push(@int1)}
    @i1.should_receive(:cleanup)
    @i1.go
  end
  
  it "should pop all the arguments" do
    Stack.cleanup
    5.times {Stack.stacks[:int].push(@int1)}
    @i1.stub!(:cleanup) # and do nothing
    @i1.go
    Stack.stacks[:int].depth.should == 3
  end
  
  it "should push the result" do
    Stack.cleanup
    Stack.stacks[:int].push(@int1)
    Stack.stacks[:int].push(@int1)
    @i1.go
    Stack.stacks[:bool].peek.value.should == false
    
    Stack.stacks[:int].push(@int1)
    Stack.stacks[:int].push(@int2)
    @i1.go
    Stack.stacks[:bool].peek.value.should == true
    
    Stack.stacks[:int].push(@int2)
    Stack.stacks[:int].push(@int1)
    @i1.go
    Stack.stacks[:bool].peek.value.should == false
  end
end


describe "IntGreaterThanQInstruction" do
  before(:each) do
    @i1 = IntGreaterThanQInstruction.instance
    @int1 = LiteralPoint.new("int", 1)
    @int2 = LiteralPoint.new("int", 2)
  end
  
  it "should be a singleton" do
    @i1.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end 
  
  it "should check that there are enough parameters" do
    6.times {Stack.stacks[:int].push(@int1)}
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    Stack.cleanup # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should successfully run #go only if all preconditions are met" do
    5.times {Stack.stacks[:int].push(@int1)}
    @i1.should_receive(:cleanup)
    @i1.go
  end
  
  it "should pop all the arguments" do
    Stack.cleanup
    5.times {Stack.stacks[:int].push(@int1)}
    @i1.stub!(:cleanup) # and do nothing
    @i1.go
    Stack.stacks[:int].depth.should == 3
  end
  
  it "should push the result" do
    Stack.cleanup
    Stack.stacks[:int].push(@int1)
    Stack.stacks[:int].push(@int1)
    @i1.go
    Stack.stacks[:bool].peek.value.should == false
    
    Stack.stacks[:int].push(@int1)
    Stack.stacks[:int].push(@int2)
    @i1.go
    Stack.stacks[:bool].peek.value.should == false
    
    Stack.stacks[:int].push(@int2)
    Stack.stacks[:int].push(@int1)
    @i1.go
    Stack.stacks[:bool].peek.value.should == true
  end
end


describe "FloatGreaterThanQInstruction" do
  before(:each) do
    @i1 = FloatGreaterThanQInstruction.instance
    @float1 = LiteralPoint.new("float", 1.0)
    @float2 = LiteralPoint.new("float", 2.0)
  end
  
  it "should be a singleton" do
    @i1.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end 
  
  it "should check that there are enough parameters" do
    6.times {Stack.stacks[:float].push(@float1)}
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    Stack.cleanup # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should successfully run #go only if all preconditions are met" do
    5.times {Stack.stacks[:float].push(@float1)}
    @i1.should_receive(:cleanup)
    @i1.go
  end
  
  it "should pop all the arguments" do
    Stack.cleanup
    5.times {Stack.stacks[:float].push(@float1)}
    @i1.stub!(:cleanup) # and do nothing
    @i1.go
    Stack.stacks[:float].depth.should == 3
  end
  
  it "should push the result" do
    Stack.cleanup
    Stack.stacks[:float].push(@float1)
    Stack.stacks[:float].push(@float1)
    @i1.go
    Stack.stacks[:bool].peek.value.should == false
    
    Stack.stacks[:float].push(@float1)
    Stack.stacks[:float].push(@float2)
    @i1.go
    Stack.stacks[:bool].peek.value.should == false
    
    Stack.stacks[:float].push(@float2)
    Stack.stacks[:float].push(@float1)
    @i1.go
    Stack.stacks[:bool].peek.value.should == true
  end
end


describe "FloatLessThanQInstruction" do
  before(:each) do
    @i1 = FloatLessThanQInstruction.instance
    @float1 = LiteralPoint.new("float", 1.0)
    @float2 = LiteralPoint.new("float", 2.0)
  end
  
  it "should be a singleton" do
    @i1.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end 
  
  it "should check that there are enough parameters" do
    6.times {Stack.stacks[:float].push(@float1)}
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    Stack.cleanup # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should successfully run #go only if all preconditions are met" do
    5.times {Stack.stacks[:float].push(@float1)}
    @i1.should_receive(:cleanup)
    @i1.go
  end
  
  it "should pop all the arguments" do
    Stack.cleanup
    5.times {Stack.stacks[:float].push(@float1)}
    @i1.stub!(:cleanup) # and do nothing
    @i1.go
    Stack.stacks[:float].depth.should == 3
  end
  
  it "should push the result" do
    Stack.cleanup
    Stack.stacks[:float].push(@float1)
    Stack.stacks[:float].push(@float1)
    @i1.go
    Stack.stacks[:bool].pop.value.should == false
    
    Stack.stacks[:float].push(@float1)
    Stack.stacks[:float].push(@float2)
    @i1.go
    Stack.stacks[:bool].pop.value.should == true
    
    Stack.stacks[:float].push(@float2)
    Stack.stacks[:float].push(@float1)
    @i1.go
    Stack.stacks[:bool].pop.value.should == false
  end
end
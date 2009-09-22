require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "IntAddInstruction" do
  it "should be a singleton" do
    i1 = IntAddInstruction.instance
    i2 = IntAddInstruction.instance
    i1.should === i2
  end
  
  [:preconditions?, :go, :outcomes].each do |methodName|
    before(:each) do
      @i1 = IntAddInstruction.instance
    end
    it "should respond to #{methodName}" do
      @i1.should respond_to(methodName)
    end 
  end
  
  describe "#preconditions?" do
    before(:each) do
      @i1 = IntAddInstruction.instance
      Stack.cleanup
      @int1 = LiteralPoint.new("int", 6)
    end
    
    it "should check that there are at least 2 ints" do
      2.times {Stack.push!(:int,@int1)}
      Stack.stacks[:int].depth.should == 2
      @i1.preconditions?.should == true
    end
    
    it "should raise an error if the preconditions aren't met" do
      1.times {Stack.push!(:int,@int1)}
      lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
    end
        
    it "should run #go only if all preconditions are met" do
      Stack.push!(:int,@int1)
      Stack.push!(:int,@int1)
      @i1.go
      Stack.stacks[:int].peek.value.should == 12
    end
  end
  
  describe "#go" do
    it "should pop the arguments"
    it "determine the result value"
    it "should raise the right exceptions if a bad thing happens"
  end
  
  describe "#outcomes" do
    it "should push! the result"
    it "should raise the right exception if something bad happens"
  end
  
end
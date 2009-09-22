require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "IntAddInstruction" do
  
  it "should be a singleton" do
    i1 = IntAddInstruction.instance
    i2 = IntAddInstruction.instance
    i1.should === i2
  end
  
  [:setup, :call, :teardown].each do |methodName|
    before(:each) do
      @i1 = IntAddInstruction.instance
    end
    it "should respond to #{methodName}" do
      @i1.should respond_to(methodName)
    end 
  end
  
  describe "#setup" do
    it "should check that there are at least 2 ints"
    it "should do something noteworthy if the preconditions aren't met"
    it "should call #call if they're met"
  end
  
  describe "#call" do
    it "should pop the arguments"
    it "determine the result value"
    it "should raise the right exceptions if a bad thing happens"
  end
  
  describe "#teardown" do
    it "should push! the result"
    it "should raise the right exception if something bad happens"
  end
  
end
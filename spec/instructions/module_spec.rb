require File.join(File.dirname(__FILE__), "/../spec_helper")

include Instructions

describe "abstract Instruction class" do
  before(:each) do
    @inst = Instruction.new()
  end
  
  it "should have a context attribute, defaulting to nil" do
    @inst.context.should == nil
  end
  
  
  it "should have a requirements attribute, defaulting to an empty hash" do
    @inst.requirements.should == {}
  end
  
  it "should have an effects attribute, defaulting to an empty hash" do
    @inst.effects.should == {}
  end
  
  it "should have a #ready? method that it will check before running" do
    @inst.should respond_to(:ready?)
    @inst.ready?.should == true
  end
  
  it "should have a #run method that makes it go" do
    @inst.should respond_to(:run)
  end
end

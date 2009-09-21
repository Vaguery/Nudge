require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Instruction" do
  
  it "should have a name parameter, with no default" do
    myI = Instruction.new("foo_bar")
    myI.name.should == "foo_bar"
    lambda {Instruction.new()}.should raise_error(ArgumentError)
  end
  
  it "should have a string as a name"
  
  it "should be a kind of program point"
  
  it "should have a requirements attribute, which defaults to an empty hash" do
    myI = Instruction.new("foo_bar")
    myI.requirements.should == {}
  end
  
  it "should have an effects attribute, which defaults to an empty hash" do
    myI = Instruction.new("foo_bar")
    myI.effects.should == {}
  end
end
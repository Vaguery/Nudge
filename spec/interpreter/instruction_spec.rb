require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Instruction" do
  
  it "should have a name parameter, with no default" do
    myI = Instruction.new("foo_bar")
    myI.name.should == "foo_bar"
    lambda {Instruction.new()}.should raise_error(ArgumentError)
  end
  
  it "should have a symbol as a name" do
    myI = Instruction.new("foo_bar")
    myI.name.should be_a_kind_of(String)
  end
  
  it "should be a kind of program point" do
    myL = Instruction.new("int_thing")
    myL.should be_a_kind_of(ProgramPoint)
  end
  
  it "should have a requirements attribute, which defaults to an empty hash" do
    myI = Instruction.new("foo_bar")
    myI.requirements.should == {}
  end
  
  it "should have an effects attribute, which defaults to an empty hash" do
    myI = Instruction.new("foo_bar")
    myI.effects.should == {}
  end
  
  describe "#tidy" do
    it "should return 'instr x' when the name is 'x'" do
      myI = Instruction.new("x")
      myI.tidy.should == "instr x"
    end
  end
  
end
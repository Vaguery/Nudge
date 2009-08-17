require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "OpCode" do
  before(:each) do
    @i1 = OpCode.new("abstract_instruction")
  end
  
  it "should be a kind of Leaf" do
    @i1.should be_a_kind_of(Leaf)
  end
  
  it "should have a name, which must be set on initialization" do
    @i1.name.should == "abstract_instruction"
    lambda {OpCode.new()}.should raise_error(ArgumentError)
  end
  
  it "should have a requirements attribute, which defaults to an empty hash" do
    @i1.requirements.should == {}
  end
  
  it "should have an effects attribute, which defaults to an empty hash" do
    @i1.effects.should == {}
  end
end
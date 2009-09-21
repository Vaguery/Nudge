require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Literal" do
  
    it "should be a kind of program point"
    
    it "should be initialized with a type and a value, with no defaults" do
      myL = Literal.new("int", 4)
      myL.should be_a_kind_of(Literal)
      myL.type.should == "int"
      myL.value.should == 4
      lambda{Literal.new()}.should raise_error(ArgumentError)
      lambda{Literal.new("bool")}.should raise_error(ArgumentError)
    end
end
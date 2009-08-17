require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "literal" do
  
  it "should be a kind of Leaf" do
    lit = Literal.new(:char, "a")
    lit.should be_a_kind_of(Leaf)
  end
  
  describe "converting to an ERC" do
    it "should allow you to cast it to an Erc with the same values" do
      fixed = Literal.new(:string, "stringValue")
      unfixed = fixed.to_erc
      unfixed.value.should == "stringValue"
      unfixed.stackname.should == :string
    end
  end
  
  describe "inspection" do
    it "should print just the value with Literal#inspect" do
      fixed = Literal.new(:string, "aString")
      fixed.inspect.should == "aString"
    end
  end
end
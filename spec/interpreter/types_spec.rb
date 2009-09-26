require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Int Type" do
  it "should be a Singleton" do
    IntType.instance.should be_a_kind_of(Singleton)
  end
  it "should parse a string from code and produce the actual value" do
    IntType.from_s("3").should == 3
    lambda{IntType.from_s()}.should raise_error
  end
  it "should return the result of self.randomize when it receives an #any_value call" do
    IntType.should_receive(:rand).and_return(1003)
    IntType.any_value.should == 3
  end
  it "should return a result from a given range when that range is passed in" do
    IntType.should_receive(:rand).and_return(0)
    IntType.randomize(9,10).should == 9
    IntType.should_receive(:rand).and_return(3)
    IntType.randomize(90,100).should == 93
  end
  it "should work for any order of lower and upper bounds"
  
  it "should default to returning the same value the Int already has"
end


describe "Bool Type" do
  it "should be a Singleton" do
    BoolType.instance.should be_a_kind_of(Singleton)
  end
  it "should parse a string from code and produce the actual value" do
    BoolType.from_s("false").should == false
    lambda{BoolType.from_s()}.should raise_error
  end
  it "should return the result of self.randomize when it receives an #any_value call" do
    BoolType.should_receive(:randomize).and_return(false)
    BoolType.any_value.should == false
  end
  
  it "should return a result from a given range when that range is passed in"
  
  it "should default to returning the same value the Int already has"
end


describe "Float Type" do
  it "should be a Singleton" do
    FloatType.instance.should be_a_kind_of(Singleton)
  end
  it "should return the result of self.randomize when it receives an #any_value call" do
    FloatType.should_receive(:randomize).and_return(-9.2)
    FloatType.any_value.should == -9.2
  end
  
  it "should return a result from a given range when that range is passed in"
  
  it "should default to returning the same value the Int already has"
end

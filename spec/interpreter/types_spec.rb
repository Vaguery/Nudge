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
  
  it "should work for any order of lower and upper bounds" do
    IntType.should_receive(:rand).and_return(3)
    IntType.randomize(100,90).should == 93
  end
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
    BoolType.should_receive(:rand).and_return(0.1)
    BoolType.any_value.should == true
    BoolType.should_receive(:rand).and_return(0.9)
    BoolType.any_value.should == false
  end
  
  it "should return a result from a biased coin when the prob of true is passed in" do
    BoolType.should_receive(:rand).and_return(0.1)
    BoolType.any_value.should == true
    BoolType.should_receive(:rand).and_return(0.1)
    BoolType.randomize(0.05).should == false
  end
end


describe "Float Type" do
  it "should be a Singleton" do
    FloatType.instance.should be_a_kind_of(Singleton)
  end
  it "should return the result of self.randomize when it receives an #any_value call" do
    FloatType.should_receive(:randomize).and_return(-9.2)
    FloatType.any_value.should == -9.2
  end
  it "should return a result from a given range when that range is passed in" do
    FloatType.should_receive(:rand).and_return(0.0)
    FloatType.randomize(0.0,10.0).should == 0.0
    FloatType.should_receive(:rand).and_return(0.5)
    FloatType.randomize(-101.101,101.101).should == 0.0
  end
  
  it "should work for any order of lower and upper bounds" do
    FloatType.should_receive(:rand).and_return(0.5)
    FloatType.randomize(101.101,-101.101).should == 0.0
  end
end

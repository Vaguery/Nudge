require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Type list" do
  before(:each) do
    NudgeType.all_types.each {|t| t.activate}
  end
  
  it "should have an #all_types [getter] method to return a list of every defined type" do
    # will be a list of every type subclassed from NudgeType
    NudgeType.all_types.should include(IntType)
  end
  
  it "should have an #active_types [getter] method to return the obvious list" do
    now = NudgeType.active_types.sort_by {|k| k.to_s}
    all = NudgeType.all_types.sort_by {|k| k.to_s}
    now.should == all
  end
  
  it "should have an #active? method that checks the current list" do
    IntType.active?.should == true
  end
  
  it "should have an #all_off method that clears out all active types" do
    BoolType.activate
    NudgeType.all_off
    NudgeType.active_types.should == []
  end
  
  
  it "should have a #deactivate/#activate methods that remove and add the class from the active_types" do
    IntType.deactivate
    IntType.active?.should == false
    BoolType.active?.should == true
    IntType.activate
    IntType.active?.should == true
    BoolType.active?.should == true
  end
  
  it "should only ever have one copy of a type on the list at once" do
    IntType.activate
    IntType.activate
    IntType.activate
    NudgeType.active_types.length.should == 4
  end
  
  it "should be possible to deactivate all types" do
    NudgeType.all_types.each {|tt| tt.activate}
    NudgeType.active_types.length.should > 0
    NudgeType.all_types.each {|tt| tt.deactivate}
    NudgeType.active_types.length.should == 0
  end
end

describe "Int Type" do
  it "should be a Singleton" do
    IntType.instance.should be_a_kind_of(Singleton)
  end
  
  it "should parse a string from code and produce the actual value" do
    IntType.from_s("3").should == 3
    lambda{IntType.from_s()}.should raise_error
  end
  it "should return the result of self.randomize when it receives an #any_value call" do
    IntType.should_receive(:rand).and_return(0)
    IntType.any_value.should == IntType.defaultLowest
    IntType.should_receive(:rand).and_return(IntType.defaultHighest-IntType.defaultLowest)
    IntType.any_value.should == IntType.defaultHighest
    
  end
  it "should return a result from a given range when that range is passed in" do
    IntType.should_receive(:rand).and_return(0.0)
    param1 = {:randomIntegerLowerBound => 9, :randomIntegerUpperBound =>10}
    IntType.random_value(param1).should == 9
    IntType.should_receive(:rand).and_return(3.0)
    param2 = {:randomIntegerLowerBound => 90, :randomIntegerUpperBound =>100}
    IntType.random_value(param2).should == 93
  end
  
  it "should work for any order of lower and upper bounds" do
    IntType.should_receive(:rand).and_return(3)
    backwards = {:randomIntegerLowerBound => 100, :randomIntegerUpperBound =>90}
    IntType.random_value(backwards).should == 93
  end
  
  it "should actually work" do
    lambda{IntType.any_value}.should_not raise_error
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
    BoolType.random_value(:randomBooleanTruthProb => 0.05).should == false
  end
  
  it "should actually work" do
    lambda{BoolType.any_value}.should_not raise_error
  end
end


describe "Float Type" do
  it "should be a Singleton" do
    FloatType.instance.should be_a_kind_of(Singleton)
  end
  it "should return the result of self.randomize when it receives an #any_value call" do
    FloatType.should_receive(:random_value).and_return(-9.2)
    FloatType.any_value.should == -9.2
  end
  it "should return a result from a given range when that range is passed in" do
    FloatType.should_receive(:rand).and_return(0.0)
    FloatType.random_value(:randomFloatLowerBound=>0.0, :randomFloatUpperBound=>10.0).should == 0.0
    FloatType.should_receive(:rand).and_return(0.5)
    FloatType.random_value(:randomFloatLowerBound=>-101.101,:randomFloatUpperBound=>101.101).should == 0.0
  end
  
  it "should work for any order of lower and upper bounds" do
    FloatType.should_receive(:rand).and_return(0.5)
    backwards = {:randomFloatLowerBound=>101.101, :randomFloatUpperBound=>-101.101}
    FloatType.random_value(backwards).should == 0.0
  end
  
  it "should actually work" do
    lambda{FloatType.any_value}.should_not raise_error
  end
  
end

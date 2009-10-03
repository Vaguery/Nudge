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
    IntType.should_receive(:rand).and_return(1003)
    IntType.any_value.should == 3
  end
  it "should return a result from a given range when that range is passed in" do
    IntType.should_receive(:rand).and_return(0)
    IntType.random_value(9,10).should == 9
    IntType.should_receive(:rand).and_return(3)
    IntType.random_value(90,100).should == 93
  end
  
  it "should work for any order of lower and upper bounds" do
    IntType.should_receive(:rand).and_return(3)
    IntType.random_value(100,90).should == 93
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
    BoolType.random_value(0.05).should == false
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
    FloatType.random_value(0.0,10.0).should == 0.0
    FloatType.should_receive(:rand).and_return(0.5)
    FloatType.random_value(-101.101,101.101).should == 0.0
  end
  
  it "should work for any order of lower and upper bounds" do
    FloatType.should_receive(:rand).and_return(0.5)
    FloatType.random_value(101.101,-101.101).should == 0.0
  end
end


describe "Code Type" do
  it "should be a Singleton" do
    CodeType.instance.should be_a_kind_of(Singleton)
  end
  
  it "should return the result of self.randomize when it receives an #any_value call" do
    CodeType.should_receive(:random_value).and_return("hi there!")
    CodeType.any_value.should == "hi there!"
  end
  
  describe "#random_skeleton" do    
    it "should accept params for points and branchiness" do
      lambda{CodeType.random_skeleton(3,1)}.should_not raise_error
    end
    
    it "should return a string filled with asterisks and 'block{}'" do
      CodeType.random_skeleton(3,0).should == "block { * *}"
      CodeType.random_skeleton(3,1).should == "block { * *}"      
      CodeType.random_skeleton(1,1).should == "block {}"
      CodeType.random_skeleton(2,2).should == "block { block {}}"
      CodeType.random_skeleton(20,3).count("}").should == 3
    end
    
    it "should limit range-check the blocks parameter" do
      CodeType.random_skeleton(1,40).should == "block {}"
      CodeType.random_skeleton(4,20).count("}").should == 4
      CodeType.random_skeleton(4,-20).count("}").should == 1
      CodeType.random_skeleton(1,-20).should == "*"
    end
  end
  describe "#randomize" do
    it "should default to a random skeleton"
    it "should allow a skeleton to be passed in as a param"
    it "should fill in the skeleton's asterisks with random one-line points"
    it "should default to uniform sampling of active instructions, channels, and samples of the active types"
    it "should allow a list of instructions to be passed in as a param"
    it "should allow a list of channel names to be passed in as a param"
    it "should allow a list of types to be passed in as a param"
    it "should allow a partially filled-in skeleton to be passed in"
    it "should use '@' as a placeholder that is not replaced with code"
    it "should be possible to iteratively build a program by shifting the '@' and '*' characters in the skeleton"
  end
end
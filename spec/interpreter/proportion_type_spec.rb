#encoding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "ProportionType" do
  
  describe "class attributes" do
    it "should have :default_lowest set to 0.0" do
      ProportionType.default_lowest.should == 0.0
    end
    
    it "should have :default_highest set to 1.0" do
      ProportionType.default_highest.should == 1.0
    end
  end
  
  describe "self.random_value" do
    it "should respond to random_value" do
      ProportionType.should respond_to(:random_value)
    end
    
    it "should call the random number generator" do
      ProportionType.should_receive(:rand).and_return(0.6)
      ProportionType.random_value
    end
    
    it "should use the :proportion_lower_bound option to set the lower end of the range" do
      ProportionType.should_receive(:rand).and_return(0.0)
      ProportionType.random_value(proportion_lower_bound:0.7).should == 0.7
    end
    
    it "should use the :proportion_upper_bound option to set the upper end of the range" do
      ProportionType.should_receive(:rand).and_return(1.0)
      ProportionType.random_value(proportion_upper_bound:0.6).should == 0.6
    end
    
    it "should raise an error if either bound is outside [0.0,1.0]" do
      lambda{ProportionType.random_value(proportion_upper_bound:71.2)}.should raise_error(ArgumentError)
      lambda{ProportionType.random_value(proportion_upper_bound:-12.0)}.should raise_error(ArgumentError)
      lambda{ProportionType.random_value(proportion_lower_bound:71.2)}.should raise_error(ArgumentError)
      lambda{ProportionType.random_value(proportion_lower_bound:-12.0)}.should raise_error(ArgumentError)
      
      lambda{ProportionType.random_value(proportion_lower_bound:0.0)}.should_not raise_error(ArgumentError)
      lambda{ProportionType.random_value(proportion_lower_bound:1.0)}.should_not raise_error(ArgumentError)
      
    end
    
    it "should raise an error if the bounds are inverted" do
      lambda{ProportionType.random_value(proportion_lower_bound:1.0,
        proportion_upper_bound:0.0)}.should raise_error(ArgumentError)
    end
  end
  
  describe "self.from_s" do
    it "should use to_f" do
      a = "0.9"
      a.should_receive(:to_f).at_least(1).times.and_return(0.9)
      ProportionType.from_s(a)
    end
    
    it "should return a value modulo 1.0" do
      ProportionType.from_s("11.0").should == 0.0
      ProportionType.from_s("-1.1").should be_close(0.9, 0.00000001)
      ProportionType.from_s("1.1").should be_close(0.1, 0.00000001)
      ProportionType.from_s("-0.0").should be_close(0.0, 0.00000001)
      
      ProportionType.from_s("1.0").should == 1.0
    end
  end
  
  describe "self.recognizes?" do
    it "should be true for floatlike things" do
      ProportionType.recognizes?(0.1).should == true
      ProportionType.recognizes?(1.0).should == true
      ProportionType.recognizes?(-111.99).should == true
    end
    
    it "should be true for Numerics that respond to to_f" do
      ProportionType.recognizes?(12).should == true
      ProportionType.recognizes?(-12).should == true
    end
    
    it "should be false for strings" do
      ProportionType.recognizes?("0.1").should == false
    end
    
    it "should be false for nil" do
      ProportionType.recognizes?(nil).should == false
    end
  end
  
  describe "self.any_value" do
    it "should pass everything along to random_value" do
      args = {foo:12, bar:13, baz:17}
      ProportionType.should_receive(:random_value).with(args)
      ProportionType.any_value(args)
    end
  end
  
end
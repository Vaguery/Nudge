#encoding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Type list" do
  it "should have an #all_types [getter] method to return a list of every defined type" do
    # will be a list of every type subclassed from NudgeType
    NudgeType.all_types.should include(NudgeType::IntType)
  end
end

describe "base class" do
  before(:all) do
    class FooType < BasicType; end
    @klass = FooType
  end
  
  {:from_s => "thing", :any_value => nil, :random_value => {}}.each do |method_name, arg|
    it "should raise an error when #{method_name} is missing" do
      args = [method_name, arg].compact
      lambda{@klass.send(*args)}.should raise_error("This class must implement #{@klass.inspect}.#{method_name}")
    end
  end 
  
  it "self.from_s should require a parameter" do
    @klass.method(:from_s).arity.should == 1
  end
  
  it "self.random_value should require a parameter" do
    @klass.method(:random_value).arity.should == 1
  end 
  
  it "self.any_value should require a parameter" do
    @klass.method(:any_value).arity.should == 0
  end 
  
  
end

describe "built-in Nudge Types :" do
  describe "Int Type" do
    it "should parse a string from code and produce the actual value" do
      IntType.from_s("3").should == 3
      lambda{IntType.from_s()}.should raise_error
    end
    
    it "should have a #recognizes? method that returns true if the arg responds to to_i" do
      IntType.recognizes?(3).should == true
      IntType.recognizes?(-3).should == true
      IntType.recognizes?(3.1321).should == true
      
      
      IntType.recognizes?(nil).should == false
      IntType.recognizes?("hi there").should == false
      
      IntType.recognizes?([1,2,3]).should == false
      IntType.recognizes?(Object.new).should == false
    end
    
    it "should return the result of self.randomize when it receives an #any_value call" do
      IntType.should_receive(:rand).and_return(0)
      IntType.any_value.should == IntType.defaultLowest
      IntType.should_receive(:rand).and_return(IntType.defaultHighest-IntType.defaultLowest)
      IntType.any_value.should == IntType.defaultHighest
    end

    it "should return a result from a given range when that range is passed in" do
      IntType.should_receive(:rand).and_return(0.0)
      param1 = {:randomIntegerLowerBound => 9, :randomIntegerUpperBound => 10}
      IntType.random_value(param1).should == 9
      IntType.should_receive(:rand).and_return(3.0)
      param2 = {:randomIntegerLowerBound => 90, :randomIntegerUpperBound => 100}
      IntType.random_value(param2).should == 93
    end

    it "should work for any order of lower and upper bounds" do
      IntType.should_receive(:rand).and_return(3)
      backwards = {:randomIntegerLowerBound => 100, :randomIntegerUpperBound => 90}
      IntType.random_value(backwards).should == 93
    end

    it "should actually work" do
      lambda{IntType.any_value}.should_not raise_error
    end

  end


  describe "Bool Type" do
    it "should parse a string from code and produce the actual value" do
      BoolType.from_s("false").should == false
      lambda{BoolType.from_s()}.should raise_error
    end
    
    it "should have a #recognizes? method that returns true if the arg is TrueClass or FalseClass" do
      BoolType.recognizes?(true).should == true
      BoolType.recognizes?(false).should == true
      
      BoolType.recognizes?(nil).should == false
      BoolType.recognizes?("false").should == false
      BoolType.recognizes?(99).should == false
      BoolType.recognizes?(0).should == false      
      
      BoolType.recognizes?([1,2,3]).should == false
      BoolType.recognizes?(Object.new).should == false
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
    it "should return the result of self.randomize when it receives an #any_value call" do
      FloatType.should_receive(:random_value).and_return(-9.2)
      FloatType.any_value.should == -9.2
    end
    
    it "should have a #recognizes? method that returns true if the arg responds to to_f" do
      FloatType.recognizes?(3.991).should == true
      FloatType.recognizes?(-3.99129).should == true
      FloatType.recognizes?(3).should == true
      FloatType.recognizes?(Complex(2,3)).should == true
      FloatType.recognizes?(Rational("2/3")).should == true
      
      FloatType.recognizes?(nil).should == false
      FloatType.recognizes?("2.123").should == false
      FloatType.recognizes?([1.1, 2.2, 3.3]).should == false
      FloatType.recognizes?(Object.new).should == false
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
end


# encoding: UTF-8
require 'spec_helper'


describe "FloatUnlimitedPower" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = FloatUnlimitedPower.new(@context)
  end
  
  describe "arguments" do
    it "should take two floats" do
      FloatUnlimitedPower::REQUIREMENTS.should == {:float=>2}
    end
  end
  
  describe "#process" do
    it "should result in the exponent in most circumstances" do
      @context.stacks[:float] << "4.0" << "-2.0"
      @inst.execute
      @context.stacks[:float][-1].should == "0.0625"
    end
    
    it "should create an :error if the result is Infinity" do
      @context.stacks[:float] << "48888888.0" << "999999999.0"
      @context.stacks[:exec] << NudgePoint.from("do float_unlimited_power")
      @context.run
      @context.stacks[:error][-1].should include("NaN")
    end
    
    it "should create an :error if the result is -Infinity" do
      @context.stacks[:float] << "-48888888.0" << "999999999.0"
      @context.stacks[:exec] << NudgePoint.from("do float_unlimited_power")
      @context.run
      @context.stacks[:error][-1].should include("NaN")
    end
    
    
    it "should create an :error if the result is Complex" do
      @context.stacks[:float] << "-1.0" << "0.5"
      @context.stacks[:exec] << NudgePoint.from("do float_unlimited_power")
      @context.run
      @context.stacks[:error][-1].should include("NaN")
    end
    
    
    it "should create an :error if it tries to divide by zero" do
      @context.stacks[:float] << "0.0" << "-3.0"
      @context.stacks[:exec] << NudgePoint.from("do float_unlimited_power")
      @context.run
      @context.stacks[:error][-1].should include("NaN")
    end
  end
  
  describe "effects" do
    it "should push the result onto the :float stack" do
      @context.stacks[:float] << "2.0" << "2.0"
      @inst.execute
      @context.stacks[:float].depth.should == 1
    end
  end
end

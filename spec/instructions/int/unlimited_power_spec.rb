# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))


describe "IntUnlimitedPower" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = IntUnlimitedPower.new(@context)
  end
  
  describe "arguments" do
    it "should take two Ints" do
      IntUnlimitedPower::REQUIREMENTS.should == {:int=>2}
    end
  end
  
  describe "#process" do
    it "should result in the exponent in most circumstances" do
      @context.stacks[:int] << "4" << "2"
      @inst.execute
      @context.stacks[:int][-1].should == "16"
    end
    
    it "should create an :error if the result is Infinity" do
      @context.stacks[:int] << "48888888" << "999999999"
      @context.stacks[:exec] << NudgePoint.from("do int_unlimited_power")
      @context.run
      @context.stacks[:error][-1].should include("NaN")
    end
    
    
    it "should create an :error if the result is -Infinity" do
      @context.stacks[:int] << "-48888888" << "999999999"
      @context.stacks[:exec] << NudgePoint.from("do int_unlimited_power")
      @context.run
      @context.stacks[:error][-1].should include("NaN")
    end
    
    
    it "should create an :error if it tries to divide by zero" do
      @context.stacks[:int] << "0" << "-3"
      @context.stacks[:exec] << NudgePoint.from("do int_unlimited_power")
      @context.run
      @context.stacks[:error][-1].should include("DivisionByZero")
    end
  end
  
  describe "effects" do
    it "should push the result onto the :int stack" do
      @context.stacks[:int] << "2" << "2"
      @inst.execute
      @context.stacks[:int].depth.should == 1
    end
  end
end

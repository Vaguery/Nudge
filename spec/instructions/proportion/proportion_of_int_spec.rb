# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))


describe "ProportionOfInt" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = ProportionOfInt.new(@context)
  end
  
  describe "arguments" do
    it "should take no args" do
      ProportionOfInt::REQUIREMENTS.should == {int:1, proportion:1}
    end
  end
  
  describe "#process" do
    it "should return an :int proportionately smaller than the :int arg" do
      @context.stacks[:int] << "10"
      @context.stacks[:proportion] << "0.23"
      @inst.execute
      @context.stacks[:int][-1].should == "2"
    end
    
    it "should round down" do
      @context.stacks[:int] << "10"
      @context.stacks[:proportion] << "0.24"
      @inst.execute
      @context.stacks[:int][-1].should == "2"
    end
    
    it "should work with negative :int values" do
      @context.stacks[:int] << "-10"
      @context.stacks[:proportion] << "0.24"
      @inst.execute
      @context.stacks[:int][-1].should == "-2"
    end
    
    it "should produce an :error if the result is Infinity" do
      @context.stacks[:int] <<  "99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999909999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999990999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"
      @context.stacks[:proportion] << "0.9999"
      @context.stacks[:exec] << NudgePoint.from("do proportion_of_int")
      @context.run
      @context.stacks[:error][-1].should include("NaN")
    end
  end
  
  describe "effects" do
    it "should push the result onto the :int stack" do
      @context.stacks[:int] << "-1000"
      @context.stacks[:proportion] << "0.2"
      @inst.execute
      @context.stacks[:int].length.should == 1
    end
  end
end

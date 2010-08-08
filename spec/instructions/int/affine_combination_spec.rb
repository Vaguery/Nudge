# encoding: UTF-8
require 'spec_helper'


describe "IntAffineInterpolation" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = IntAffineCombination.new(@context)
  end
  
  describe "arguments" do
    it "should take no args" do
      IntAffineCombination::REQUIREMENTS.should == {int:2, float:1}
    end
  end
  
  describe "#process" do
    it "should return an :int proportionately between the two :int args" do
      @context.stacks[:int] << "10" << "20"
      @context.stacks[:float] << "3.0"
      @inst.execute
      @context.stacks[:int][-1].should == "40"
    end
    
    it "should produce an :error if the result is Infinity" do
      @context.stacks[:int] << "0" << "999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999099999999999999999999999999999999999999999999999999999"
      @context.stacks[:float] << "999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999099999999999999999999999999999999999999999999999999999"
      @context.stacks[:exec] << NudgePoint.from("do int_affine_combination")
      @context.run
      @context.stacks[:error][-1].should include("NaN")
    end
    
    it "should produce an :error if the result is -Infinity" do
      @context.stacks[:int] << "0" << "-999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999099999999999999999999999999999999999999999999999999999"
      @context.stacks[:float] << "999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999099999999999999999999999999999999999999999999999999999"
      @context.stacks[:exec] << NudgePoint.from("do int_affine_combination")
      @context.run
      @context.stacks[:error][-1].should include("NaN")
    end
    
  end
  
  describe "effects" do
    it "should push the result onto the :int stack" do
      @context.stacks[:int] << "10" << "20"
      @context.stacks[:float] << "0.2"
      @inst.execute
      @context.stacks[:int].length.should == 1
    end
  end
end

# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))


describe "IntAffineInterpolation" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = IntAffineInterpolation.new(@context)
  end
  
  describe "arguments" do
    it "should take no args" do
      IntAffineInterpolation::REQUIREMENTS.should == {int:2, proportion:1}
    end
  end
  
  describe "#process" do
    it "should return an :int proportionately between the two :int args" do
      @context.stacks[:int] << "10" << "20"
      @context.stacks[:proportion] << "0.2"
      @inst.execute
      @context.stacks[:int][-1].should == "12"
    end
    
    it "should produce an :error if the result is Infinity" do
      @context.stacks[:int] << "0" << "99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999909999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999990999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"
      @context.stacks[:proportion] << "0.9"
      @context.stacks[:exec] << NudgePoint.from("do int_affine_interpolation")
      @context.run
      @context.stacks[:error][-1].should include("NaN")
    end
  end
  
  describe "effects" do
    it "should push the result onto the :int stack" do
      @context.stacks[:int] << "10" << "20"
      @context.stacks[:proportion] << "0.2"
      @inst.execute
      @context.stacks[:int].length.should == 1
    end
  end
end

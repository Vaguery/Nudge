# encoding: UTF-8
require 'spec_helper'


describe "IntDivmod" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = IntDivmod.new(@context)
  end
  
  describe "arguments" do
    it "should take two :int args" do
      IntDivmod::REQUIREMENTS.should == {int:2}
    end
  end
  
  describe "#process" do
    it "should return two :ints just as with Knuth's (and Ruby's) divmod method" do
      @context.stacks[:int] << "23" << "12"
      @inst.execute
      @context.stacks[:int].should == ["1", "11"]
    end
    
    # Ruby uses Bignum, so Infinity results don't seem to crop up in this instruction
  end
  
  describe "effects" do
    it "should push the result onto the :int stack" do
      @context.stacks[:int] << "12" << "5"
      @inst.execute
      @context.stacks[:int].length.should == 2
    end
  end
end

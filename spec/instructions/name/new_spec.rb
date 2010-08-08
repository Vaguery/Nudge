# encoding: UTF-8
require 'spec_helper'


describe "NameNew" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = NameNew.new(@context)
  end
  
  describe "arguments" do
    it "should need no args" do
      NameNew::REQUIREMENTS.should == {}
    end
  end
  
  describe "#process" do
    it "should push a novel :name string" do
      pending "but WHAT string?"
    end
  end
  
  describe "effects" do
    it "should push the result onto the :name stack" do
      pending
      @inst.execute
      @context.stacks[:name].length.should == 1
    end
  end
end

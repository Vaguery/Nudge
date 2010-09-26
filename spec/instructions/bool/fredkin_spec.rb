# encoding: UTF-8
require 'spec_helper'


describe "BoolFredkin" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = BoolFredkin.new(@context)
  end
  
  describe "arguments" do
    it "should take three :bool args" do
      BoolFredkin::REQUIREMENTS.should == {bool:3}
    end
  end
  
  describe "#process and #effects" do
    it "should return the same three :bool values if the control arg is false" do
      @context.stacks[:bool] << "false" << "false" << "true"
      @inst.execute
      @context.stacks[:bool][-3..-1].should == ["false", "false", "true"]
    end
    
    it "should return the same three :bool values in a new order if the control arg is true" do
      @context.stacks[:bool] << "true" << "false" << "true"
      @inst.execute
      @context.stacks[:bool][-3..-1].should == ["true", "true", "false"]
    end
  end
end

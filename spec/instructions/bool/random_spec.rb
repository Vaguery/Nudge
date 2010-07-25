# encoding: UTF-8
require 'spec_helper'


describe "BoolRandom" do
  before(:each) do
    @context = Outcome.new({})
  end
  
  
  describe "needs" do
    it "needs nothing" do
      BoolRandom::REQUIREMENTS.should == {}
    end
  end
  
  
  describe "#process()" do
    it "returns the result of BoolType.random"
  end
end

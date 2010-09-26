# encoding: UTF-8
require 'spec_helper'


describe "BoolToffoli" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = BoolToffoli.new(@context)
  end
  
  describe "arguments" do
    it "should take three :bool args" do
      BoolToffoli::REQUIREMENTS.should == {bool:3}
    end
  end
  
  describe "#process and #effects" do
    it "should be easier to spec this :/" do
      pending
    end
  end
end

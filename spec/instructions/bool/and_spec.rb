# encoding: UTF-8
require 'spec_helper'


describe "BoolAnd" do
  before(:each) do
    @context = Outcome.new({})
  end
  
  
  describe "needs" do
    it "needs 2 :bool items" do
      BoolAnd::REQUIREMENTS.should == {bool:2}
    end
  end
  
  
  describe "#process()" do
    # this seems kludgy because :&& can't be mocked (?)
    it "pushes the arguments' logical && onto the :bool stack" do
      @context.stacks[:bool] = ["true", "true"]
      BoolAnd.new(@context).execute
      @context.stacks[:bool].should == ["true"]
      
      @context.stacks[:bool] = ["true", "false"]
      BoolAnd.new(@context).execute
      @context.stacks[:bool].should == ["false"]
      
      @context.stacks[:bool] = ["false", "true"]
      BoolAnd.new(@context).execute
      @context.stacks[:bool].should == ["false"]
      
      @context.stacks[:bool] = ["false", "false"]
      BoolAnd.new(@context).execute
      @context.stacks[:bool].should == ["false"]
    end
  end
end

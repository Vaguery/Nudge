# encoding: UTF-8
require 'spec_helper'


describe "BoolEqualQ" do
  before(:each) do
    @context = Outcome.new({})
  end
  
  
  describe "needs" do
    it "needs 2 :bool items" do
      BoolEqualQ::REQUIREMENTS.should == {bool:2}
    end
  end
  
  
  describe "#process()" do
    it "applies :== to the args and pushes the result onto :bool" do
      @context.stacks[:bool] = ["false", "true"]
      true.should_receive(:==).and_return(false)
      BoolEqualQ.new(@context).execute
      @context.stacks[:bool].should == ["false"]
    end
  end
end

# encoding: UTF-8
require 'spec_helper'


describe "BoolOr" do
  before(:each) do
    @context = Outcome.new({})
  end
  
  
  describe "needs" do
    it "needs 1 :bool item" do
      BoolOr::REQUIREMENTS.should == {bool:2}
    end
  end
  
  
  describe "#process()" do
    it "applies :|| to the args and pushes the result onto :bool"
  end
end

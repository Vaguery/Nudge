# encoding: UTF-8
require 'spec_helper'


describe "BoolNot" do
  before(:each) do
    @context = Outcome.new({})
  end
  
  
  describe "needs" do
    it "needs 1 :bool item" do
      BoolNot::REQUIREMENTS.should == {bool:1}
    end
  end
  
  
  describe "#process()" do
    it "applies :! to the arg and pushes the result onto :bool"
  end
end

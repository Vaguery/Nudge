# encoding: UTF-8
require File.expand_path("../../nudge", File.dirname(__FILE__))

describe "Outcome" do
  describe ".new(variable_bindings)" do
    it "returns a new Outcome with 0 points evaluated" do
      Outcome.new({}).instance_variable_get(:@points_evaluated).should === 0
    end
  end
  
  
  describe "stacks" do
    it "should be a Hash with a default value of an empty Array" do
      Outcome.new({}).stacks[:aodfa].should == []
    end
  end
  
  
  describe "wtf_stacks" do
    it "should be a Hash with a default value of an empty Array" do
      Outcome.new({}).wtf_stacks[:jajk].should == []
    end
  end
  
end

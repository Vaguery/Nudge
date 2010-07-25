# encoding: UTF-8
require File.expand_path("../../nudge", File.dirname(__FILE__))

describe "RefPoint" do
  describe ".new (variable_name: Symbol)" do
    it "returns a new RefPoint containing the given variable_name" do
      DoPoint.new(:x).instance_variable_get(:@variable_name) === :x
    end
  end
  
  describe "#evaluate (outcome_data: Outcome)" do
    it "pushes the value associated with its @variable_name to the outcome_data stack" do
      outcome_data = Outcome.new(:x1 => Value.new(:int, 100))
      RefPoint.new(:x1).evaluate(outcome_data.begin)
      
      outcome_data.stacks[:int][0].should == '100'
      outcome_data.stacks[:name].length.should == 0
    end
    
    it "pushes its @variable_name to the :name stack if there is no associated value" do
      outcome_data = Outcome.new(:x1 => Value.new(:int, 100))
      RefPoint.new(:x2).evaluate(outcome_data.begin)
      
      outcome_data.stacks[:int].length.should == 0
      outcome_data.stacks[:name][0].should == "x2"
    end
  end
end

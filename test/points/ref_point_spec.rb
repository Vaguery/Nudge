require 'nudge'

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
    end
  end
end

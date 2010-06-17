require 'nudge'

describe "RefPoint" do
  describe ".new(variable_id)" do
    it "returns a new RefPoint containing the given variable_id" do
      DoPoint.new(:x).instance_variable_get(:@variable_id) === :x
    end
  end
  
  describe "#evaluate(outcome_data)" do
    it "pushes the value associated with its @variable_id to the outcome_data stack" do
      outcome_data = Outcome.new(:x1 => Value.new(:int, 100))
      RefPoint.new(:x1).evaluate(outcome_data)
      
      outcome_data.stacks[:int][0].should == '100'
    end
  end
end

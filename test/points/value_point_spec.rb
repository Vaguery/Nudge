require 'nudge'

describe "ValuePoint" do
  describe ".new (value_type: Symbol, string: String)" do
    it "returns a new ValuePoint containing the given value_type and string" do
      point = ValuePoint.new(:int, 5)
      point.instance_variable_get(:@value_type) === :int
      point.instance_variable_get(:@string) === 5
    end
  end
  
  describe "#evaluate (outcome_data: Outcome)" do
    it "pushes its string to the outcome_data stack identified by its value_type" do
      outcome_data = Outcome.new({})
      ValuePoint.new(:int, "5").evaluate(outcome_data.begin)
      outcome_data.instance_variable_get(:@stacks)[:int][0].should === "5"
    end
  end
end

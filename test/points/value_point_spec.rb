require 'nudge'

describe "ValuePoint" do
  describe ".new(type_id, string)" do
    it "returns a new ValuePoint containing the given type_id and string" do
      point = ValuePoint.new(:int, 5)
      point.instance_variable_get(:@type_id) === :int
      point.instance_variable_get(:@string) === 5
    end
  end
  
  describe "#evaluate(outcome_data)" do
    it "pushes its string to the outcome_data stack identified by its type_id" do
      outcome_data = Outcome.new({})
      ValuePoint.new(:int, "5").evaluate(outcome_data)
      outcome_data.instance_variable_get(:@stacks)[:int][0].should === "5"
    end
  end
end

require 'nudge'

describe "Outcome" do
  describe ".new(variable_bindings)" do
    it "returns a new Outcome with 0 points evaluated" do
      Outcome.new({}).instance_variable_get(:@points_evaluated).should === 0
    end
  end
end

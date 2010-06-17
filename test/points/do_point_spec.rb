require 'nudge'

describe "DoPoint" do
  describe ".new(instruction_id)" do
    it "returns a new DoPoint containing the given instruction_id" do
      DoPoint.new(:inst).instance_variable_get(:@instruction_id) === :inst
    end
  end
  
  describe "#evaluate(outcome_data)" do
    it "makes and executes a new instruction based on its instruction_id" do
      pending
    end
  end
end

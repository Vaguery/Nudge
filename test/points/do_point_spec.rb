require 'nudge'

describe "DoPoint" do
  describe ".new (instruction_name: Symbol)" do
    it "returns a new DoPoint containing the given instruction_name" do
      DoPoint.new(:inst).instance_variable_get(:@instruction_name) === :inst
    end
  end
  
  describe "#evaluate (outcome_data: Outcome)" do
    it "makes and executes a new instruction based on its instruction_name" do
      pending
    end
  end
end

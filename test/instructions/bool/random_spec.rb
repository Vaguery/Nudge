require './nudge'

describe "Instruction::BoolRandom" do
  describe "#process()" do
    it "pushes one randomly chosen \"true\" or \"false\" onto the :bool stack" do
      script = "block { do bool_random }"
      outcome = Executable.new(script).run
      outcome.stacks[:bool].length.should == 1
      %w(true false).include?(outcome.stacks[:bool][-1]).should be_true
    end
  end
end

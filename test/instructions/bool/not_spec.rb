require 'nudge'

describe "Instruction::BoolNot" do
  describe "#process()" do
    it "pops the top item off the :bool stack and pushes its logical ! onto the :bool stack" do
      script = "block { value «bool» do bool_not }\n«bool» false"
      outcome = Executable.new(script).run
      outcome.stacks[:bool].length.should == 1
      outcome.stacks[:bool][-1].should == "true"
    end
  end
end

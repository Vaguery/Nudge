require 'nudge'

describe "Instruction::BoolEqualQ" do
  describe "#process()" do
    it "pops the top two items off the :bool stack and pushes their logical == onto the :bool stack" do
      script = "block { value «bool» value «bool» do bool_equal_q }\n«bool» false \n«bool» false"
      outcome = Executable.new(script).run
      outcome.stacks[:bool].length.should == 1
      outcome.stacks[:bool][-1].should == "true"
    end
  end
end

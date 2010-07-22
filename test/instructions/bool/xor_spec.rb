# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))

describe "BoolXor" do
  describe "#process()" do
    it "pops the top two items off the :bool stack and pushes their logical ^ onto the :bool stack" do
      script = "block { value «bool» value «bool» do bool_xor }\n«bool» true \n«bool» false"
      outcome = Executable.new(script).run
      outcome.stacks[:bool].length.should == 1
      outcome.stacks[:bool][-1].should == "true"
    end
  end
end

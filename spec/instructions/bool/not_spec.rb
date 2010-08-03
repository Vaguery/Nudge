# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))

describe "BoolNot" do
  describe "#process" do
    it "pops the top item off the :bool stack and pushes its logical ! onto the :bool stack" do
      script = "block { value «bool» do bool_not }\n«bool» false"
      exe = NudgeExecutable.new(script).run
      exe.stacks[:bool].length.should == 1
      exe.stacks[:bool][-1].should == "true"
    end
  end
end

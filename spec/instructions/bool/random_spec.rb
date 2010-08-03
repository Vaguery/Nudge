# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))

describe "BoolRandom" do
  describe "#process" do
    it "pushes one randomly chosen \"true\" or \"false\" onto the :bool stack" do
      script = "block { do bool_random }"
      exe = NudgeExecutable.new(script).run
      exe.stacks[:bool].length.should == 1
      %w(true false).include?(exe.stacks[:bool][-1]).should be_true
    end
  end
end

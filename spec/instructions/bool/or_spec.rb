# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))

describe "BoolOr" do
  describe "#process" do
    it "pops the top two items off the :bool stack and pushes their logical || onto the :bool stack" do
      script = "block { value «bool» value «bool» do bool_or }\n«bool» true \n«bool» false"
      exe = NudgeExecutable.new(script).run
      exe.stacks[:bool].length.should == 1
      exe.stacks[:bool][-1].should == "true"
    end
  end
end

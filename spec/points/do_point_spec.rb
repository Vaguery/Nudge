# encoding: UTF-8
require File.expand_path("../../nudge", File.dirname(__FILE__))

describe "DoPoint" do
  describe ".new (instruction_name: Symbol)" do
    it "sets @instruction_name" do
      DoPoint.new(:inst).instance_variable_get(:@instruction_name).should == :inst
    end
  end
  
  describe "#evaluate (executable: NudgeExecutable)" do
    it "calls NudgeInstruction.execute with @instruction_name" do
      exe = NudgeExecutable.new("do inst")
      point = DoPoint.new(:inst)
      
      NudgeInstruction.should_receive(:execute).with(:inst, exe)
      
      point.evaluate(exe)
    end
  end
end

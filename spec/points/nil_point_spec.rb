# encoding: UTF-8
require File.expand_path("../../nudge", File.dirname(__FILE__))

describe "NilPoint" do
  describe ".new (script: Symbol)" do
    it "sets @script" do
      NilPoint.new("ref 9").instance_variable_get(:@script).should == "ref 9"
    end
  end
  
  describe "#evaluate (executable: Interpreter)" do
    it "leaves the executable state unchanged" do
      exe = NudgeExecutable.new("ref x").bind({:x => Value.new(:int, 100)})
      stacks = exe.stacks.dup
      variable_bindings = exe.variable_bindings.dup
      
      NilPoint.new("ref 9").evaluate(exe)
      
      exe.stacks.should == stacks
      exe.variable_bindings.should == variable_bindings
    end
  end
  
  describe "#points" do
    it "returns 0" do
      NilPoint.new("ref 9").points.should == 0
    end
  end
end

# encoding: UTF-8
require File.expand_path("../../nudge", File.dirname(__FILE__))

describe "RefPoint" do
  describe ".new (variable_name: Symbol)" do
    it "sets @variable_name" do
      RefPoint.new(:x).instance_variable_get(:@variable_name).should == :x
    end
  end
  
  describe "#evaluate (executable: NudgeExecutable)" do
    it "pushes the associated value to the appropriate stack" do
      exe = NudgeExecutable.new("ref x").bind(:x => Value.new(:int, 100))
      RefPoint.new(:x).evaluate(exe)
      
      exe.stacks[:int].pop_value.should == 100
    end
    
    it "pushes @variable_name to the :name stack if there is no associated value" do
      exe = NudgeExecutable.new("ref x")
      RefPoint.new(:x).evaluate(exe)
      
      exe.stacks[:name].last.should == "x"
    end
    
    it "pushes @variable_name to the :name stack if lookup is disallowed" do
      x = Value.new(:int, 100)
      exe = NudgeExecutable.new("ref x").bind(:x => x)
      exe.instance_variable_set(:@allow_lookup, false)
      RefPoint.new(:x).evaluate(exe)
      
      exe.stacks[:name].last.should == "x"
    end
    
    it "sets @allow_lookup to true" do
      exe = NudgeExecutable.new("ref x")
      exe.instance_variable_set(:@allow_lookup, false)
      RefPoint.new(:x).evaluate(exe)
      
      exe.instance_variable_get(:@allow_lookup).should == true
    end
  end
end

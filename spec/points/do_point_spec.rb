# encoding: UTF-8
require File.expand_path("../../nudge", File.dirname(__FILE__))

describe "DoPoint" do
  describe ".new (instruction_name: Symbol)" do
    it "returns a new DoPoint containing the given instruction_name" do
      DoPoint.new(:inst).instance_variable_get(:@instruction_name) === :inst
    end
  end
  
  describe "#evaluate (outcome_data: Outcome)" do
    it "makes and executes a new instruction based on its instruction_name" do
      pending
    end
  end
  
  describe "DoPoint execution errors" do
    it "pushes an :error if the arguments aren't there" do
      @context = Outcome.new({})
      @context.stacks[:int] = "1"
      DoPoint.new(:int_add).evaluate(@context.begin)
      @context.stacks[:error][-1].should include "missing arguments"
    end
    
    it "pushes an :error if the instruction_name is not recognized" do
      @context = Outcome.new({})
      lambda{DoPoint.new(:foo_bar).evaluate(@context.begin)}.should_not raise_error
      @context.stacks[:error][-1].should include ":foo_bar not recognized"
    end
    
    it "should count a bad instruction as one step" do
      @context = Outcome.new({})
      DoPoint.new(:foo_bar).evaluate(@context.begin)
      @context.points_evaluated.should == 1
    end
  end
end

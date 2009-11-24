require File.join(File.dirname(__FILE__), "./../../../spec_helper")
include Nudge


describe TestCase do
  describe "bindings" do
    it "should have a Hash of independent variable names and assigned values" do
      TestCase.new.should respond_to(:bindings)
    end
  end
  
  describe "expectations" do
    it "should have a Hash of dependent variable names and expected values" do
      TestCase.new.should respond_to(:expectations)
    end
  end
  
  describe "gauges" do
    it "should have a Hash of Proc objects that measure the observed values" do
      TestCase.new.should respond_to(:gauges)
    end
    
    it "should have one gauge for every expectation" do
      lambda{TestCase.new(
        :expectations => {"y1"=>31},
        :gauges => {"h"=>Proc.new {} } )}.should raise_error
      lambda{TestCase.new(
        :expectations => {"y1"=>31},
        :gauges => {"y1"=>Proc.new {} } )}.should_not raise_error
    end
  end
end





describe TestCaseEvaluator do
  describe "initialize" do
    it "should have a name" do
      lambda{TestCaseEvaluator.new()}.should raise_error(ArgumentError)
      lambda{TestCaseEvaluator.new(name:"boolean_multiplexer_SSE")}.should_not raise_error
    end
  end
  
  describe "evaluate" do
    before(:each) do
      @tce = TestCaseEvaluator.new(name:"error")
      @dudes = Batch[
        Individual.new("sample int(12)"),
        Individual.new("sample int(-9912)"),
        Individual.new("sample bool(false)"),
        Individual.new("block { sample int(99) sample int(12)}")
      ]
      @cases = [
        TestCase.new(
          :expectations => {"y" => 12},
          :gauges => {"y" => Proc.new {|interp| interp.stacks[:int].peek.value}}
        ),
        TestCase.new(
          :expectations => {"y" => -9912},
          :gauges => {"y" => Proc.new {|interp| interp.stacks[:int].peek.value}}
        )
      ]
    end
    
    it "should raise an exception if the batch argument isn't a Batch" do
      lambda{@tce.evaluate()}.should raise_error(ArgumentError)
      lambda{@tce.evaluate(@dudes)}.should_not raise_error(ArgumentError)
    end
    
    it "should raise an exception if it can't evaluate an Individual" do
      lambda{@tce.evaluate(Batch[Individual.new("blah_de_blah")])}.should raise_error(ArgumentError)
    end
    
    it "should assign a numeric score to all the Individuals in the Batch" do
      @dudes.each {|dude| dude.scores["error"].should == nil}
      @tce.evaluate(@dudes, @cases)
      @dudes.each {|dude| dude.scores["error"].kind_of?(Numeric).should == true}
    end
    
    it "should loop over the test cases to determine the error" do
      "intentional placeholder FAIL".should == false
      # See the comments inside the function
      @tce.evaluate(@dudes, @cases)
      
    end
    
  end
end
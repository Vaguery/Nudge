require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe "SummedAbsoluteError" do
  describe "evaluate method" do
    before(:all) do
      @myCounter = ProgramPointsEvaluator.new
    end
    
    it "should have a #name attribute that is a Symbol, which it'll use to record scores"
    
    it "should have a set of #training_cases, established during initialization"
    
    it "should take an Individual as a parameter"
    
    it "should run the Individual using each of its training cases"
    
    it "should use #observe to measure (or caulculate) the salient value in one training case"
    
    it "should be able to run #observe even when no value is generated"
    
    it "should return the largest absolute error over all training cases"
    
    it "should by default write the result into the Individual's #scores hash using its #name"
    
    it "should take an optional Boolean parameter that tells not to bother writing the score"
    
    it "should be able to handle training cases in which there are unassigned bindings"
    
  end
end
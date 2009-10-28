require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe "SummedSquaredError evaluator" do
  before(:each) do
    @myMistake = SummedSquaredError.new
    @greatResults = [Result.new(10,10)]
    @dumbResults = [Result.new(0,100)]
    @nilResults = [Result.new(10,nil)]
    @sandbox = Interpreter.new("sample int(8812)")
  end
  
  describe "initialization" do
    it "should have the name :summed_squared_error" do
      @myMistake.name.should == :summed_squared_error
    end
    
    it "should have an optional #penalty value, set by default to 100000" do
      @myMistake.penalty.should == 1000000
      SummedSquaredError.new(999).penalty.should == 999
    end
    
  end
  
  
  describe "#analyze" do
    it "should take a Result instance and an Interpreter (which has probably already been run)" do
      lambda{@myMistake.analyze()}.should raise_error(ArgumentError)
      lambda{@myMistake.analyze(false)}.should raise_error(ArgumentError)
      lambda{@myMistake.analyze(@nilresults[0],@sandbox)}.should_not raise_error(ArgumentError)
      lambda{@myMistake.analyze(@nilresults[0],@sandbox.run)}.should_not raise_error(ArgumentError)
    end
    
    it "should call the #probe Proc attribute" do
      @myMistake.probe.should_receive(:call)
      @myMistake.analyze(@greatResults[0],@sandbox)
    end
    
  end
  
  
  describe "#aggregate" do
    it "should accept a list of Result objects" do
      lambda{@myMistake.aggregate}.should raise_error(ArgumentError)
      lambda{@myMistake.aggregate(121)}.should raise_error(ArgumentError)
      lambda{@myMistake.aggregate(@dumbResults)}.should_not raise_error(ArgumentError)
    end
    
    it "should iterate over the Results" do
      @greatResults.should_receive(:each)
      @myMistake.aggregate(@greatResults)
    end
    
    it "should return the actual SSE" do
      @myMistake.aggregate(@greatResults).should == 0
      @myMistake.aggregate(@dumbResults).should == 10000
      @myMistake.aggregate(@dumbResults+@greatResults).should == 10000
    end
    
    it "should use its #penalty value for missing observations" do
      @myMistake.aggregate(@nilResults).should == 1000000
    end
  end
end
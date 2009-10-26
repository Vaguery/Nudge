require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe "SummedSquaredError evaluator" do
  before(:each) do
    @myMistake = SummedSquaredError.new
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

  describe "#aggregate" do
    before(:each) do
      @greatResults = [Result.new(10,10)]
      @dumbResults = [Result.new(0,100)]
      @nilResults = [Result.new(10,nil)]
    end
    
    it "should accept a list of Result objects" do
      lambda{@myMistake.aggregate}.should raise_error(ArgumentError)
      lambda{@myMistake.aggregate(121)}.should raise_error(ArgumentError)
      lambda{@myMistake.aggregate(@dumbResults)}.should_not raise_error(ArgumentError)
    end
    
    it "should iterate over the Results" do
      @greatResults.should_receive(:inject)
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
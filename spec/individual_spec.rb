require File.join(File.dirname(__FILE__), "./spec_helper")
include Nudge

describe "Individual" do
  describe "initialization" do
    before(:each) do
      @i1 = Individual.new("literal :bool, false")
    end
    
    it "should have a genome string, with no default value" do
      @i1.genome.should be_a_kind_of(String)
      lambda{Individual.new()}.should raise_error
    end
    it "should have a scores hash, which is empty" do
      @i1.scores.should == {}
    end
    it "should have a timestamp, which is when (wall clock time) it was made" do
      @i1.timestamp.should be_a_kind_of(Time)
    end
    
  end
end
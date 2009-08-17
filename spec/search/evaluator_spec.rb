require File.join(File.dirname(__FILE__), "/../spec_helper")

include Nudge

describe "structural evaluators" do
  describe "root length" do
    it "should take an Individual as input"
    it "should return the number of points in the program's base level"
  end
  
  describe "total points" do
    it "should take an Individual as input"
    it "should return the number of points in the whole program"
  end
  
  describe "ERCs" do
    it "should take an Individual as input"
    it "should return the number of ERCs anywhere in the program"
  end
end


describe "one-off evaluators" do
  it "should run the program once"
end


describe "sampling evaluators" do
  it "should run the program a number of times"
  it "should report an estimate of the sampled value"
end
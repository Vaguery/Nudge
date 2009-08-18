require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "subtree crossover" do
  it "should accept an array containing any number of parents"
  it "should accept N≠2 parents, and simply crossover between neighbors in a cycle"
  it "should work with an arry containing one parent, just self-crossing it and return 1 child"
  it "should swap a whole subtree from each parent to another create a derived offspring"
  it "should return an array of offspring the same size as the parent set"
end


describe "point deletion" do
  it "should take an array containing any number of parents"
  it "should select a point at random from each parent"
  it "should create an offspring for each parent, with a random point removed"
  it "should return one offspring for each parent passed in"
end


describe "size-preserving point mutation" do
  it "should take an array containing any number of parents"
  it "should select a point at random from each parent"
  it "should create an offspring for each parent, with a random point replaced"
  it "should not change the number of points from parent to offspring"
  it "should return one offspring for each parent passed in"
end


describe "ERC randomize" do
  it "should take an array containing any number of parents"
  it "should re-randomize the value of every ERC in each parent"
  it "should return one offspring for each parent passed in"
end


describe "point duplication" do
  it "should take an array containing any number of parents"
  it "should select a point at random from each parent"
  it "should create an offspring for each parent, with that point duplicated and adjacent"
  it "should return one offspring for each parent passed in"
end


describe "point flattening" do
  it "should take an array containing any number of parents"
  it "should select a point at random from each parent"
  it "should create an offspring for each parent, with that point flattened"
  it "should return one offspring for each parent passed in"
end
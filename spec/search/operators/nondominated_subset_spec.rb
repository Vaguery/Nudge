require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "nondominated_subset operator" do
  before(:each) do
    @myNondominatedScreener = NondominatedSubset.new
    @myGuesser = RandomGuess.new
    @params = {:points => 3, :instructions => [IntAddInstruction], :types => [IntType]}
    @results = []
  end
  
  it "should be a kind of SearchOperator" do
    @myNondominatedScreener.should be_a_kind_of(SearchOperator)
  end
  
  it "the #all_known_scores method should return an Array with the union of all scores keys in the crowd" do
    twoGuys = @myGuesser.generate(@params,2)
    twoGuys[0].scores = {"x2" => 612, "y2" => 77, "x3" => 712}
    twoGuys[1].scores = {"y1" => 2, "x1" => 3, "x2" => 4}
    @myNondominatedScreener.all_known_scores(twoGuys).sort.should == ["x1","x2", "x3", "y1", "y2"].sort
  end
  
  it "the #all_shared_scores method should return an Array of the keys of the #scores hashes in the crowd" do
    twoGuys = @myGuesser.generate(@params,2)
    twoGuys[0].scores = {"x2" => 612, "x1" => 77, "x3" => 712}
    twoGuys[1].scores = {"x2" => 2, "x1" => 3, "x3" => 4}
    @myNondominatedScreener.all_shared_scores(twoGuys).sort.should == ["x1","x2", "x3"].sort
    
    twoGuys[0].scores = {"x3" => 712, "something_else" => 88}
    twoGuys[1].scores = {"x2" => 2, "x1" => 3, "x3" => 4}
    @myNondominatedScreener.all_shared_scores(twoGuys).sort.should == ["x3"].sort
  end
  
  it "can use the 'template' parameter to extract a vector of scores"
  
  it "the 'template' parameter should default to the intersection of scores keys"
  
  it "should produce an array of Individuals when it receives #generate; at least one"
  
  it "should work the same no matter what the scores hash order"
  
  it "should not clone, but simply return references to individuals in the original set"
end
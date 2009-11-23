require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "nondominated_subset operator" do
  before(:each) do
    @myNondominatedScreener = NondominatedSubsetOperator.new
    @params = {:points => 3, :instructions => [IntAddInstruction], :types => [IntType]}
    @myGuesser = RandomGuessOperator.new(@params)
    @twoGuys = @myGuesser.generate(2)
    @results = []
  end
  
  it "should be a kind of SearchOperator" do
    @myNondominatedScreener.should be_a_kind_of(SearchOperator)
  end
  
  it "the #all_known_scores method should return an Array with the union of all scores keys in the crowd" do
    @twoGuys[0].scores = {"x2" => 612, "y2" => 77, "x3" => 712}
    @twoGuys[1].scores = {"y1" => 2, "x1" => 3, "x2" => 4}
    @myNondominatedScreener.all_known_scores(@twoGuys).sort.should == ["x1","x2", "x3", "y1", "y2"].sort
  end
  
  it "the #all_shared_scores method should return an Array of the keys of the #scores hashes in the crowd" do
    twoGuys = @myGuesser.generate(2)
    twoGuys[0].scores = {"x2" => 612, "x1" => 77, "x3" => 712}
    twoGuys[1].scores = {"x2" => 2, "x1" => 3, "x3" => 4}
    @myNondominatedScreener.all_shared_scores(twoGuys).sort.should == ["x1","x2", "x3"].sort
    
    twoGuys[0].scores = {"x3" => 712, "something_else" => 88}
    twoGuys[1].scores = {"x2" => 2, "x1" => 3, "x3" => 4}
    @myNondominatedScreener.all_shared_scores(twoGuys).sort.should == ["x3"].sort
  end
  
  it "should produce an array of Individual objects when it receives #generate; at least one" do
    twoGuys = @myGuesser.generate(2)
    twoGuys[0].scores = {"x2" => 612, "x1" => 77, "x3" => 712}
    twoGuys[1].scores = {"x2" => 2, "x1" => 3, "x3" => 4}
    @myNondominatedScreener.generate(twoGuys).should be_a_kind_of(Array)
    @myNondominatedScreener.generate(twoGuys)[0].should be_a_kind_of(Individual)
  end
  
  it "should work, passing along references not clones to the original guys" do
    twoGuys = @myGuesser.generate(2)
    twoGuys[0].scores = {"x2" => 612, "x1" => 77, "x3" => 712}
    twoGuys[1].scores = {"x2" => 2, "x1" => 3, "x3" => 4}
    @myNondominatedScreener.generate(twoGuys).should include(twoGuys[1])
    
    twoGuys[0].scores = {"x2" => 1, "x1" => 2, "x3" => 3}
    twoGuys[1].scores = {"x2" => 2, "x1" => 1, "x3" => 3}
    @myNondominatedScreener.generate(twoGuys).length.should == 2
    @myNondominatedScreener.generate(twoGuys).should include(twoGuys[0])
    @myNondominatedScreener.generate(twoGuys).should include(twoGuys[1])
  end
  
  it "should work the same no matter what the scores hash order" do
    twoGuys = @myGuesser.generate(2)
    twoGuys[0].scores = {"x1" => 77, "x3" => 712,"x2" => 612}
    twoGuys[1].scores = {"x2" => 2, "x1" => 3, "x3" => 4}
    @myNondominatedScreener.generate(twoGuys).should include(twoGuys[1])
    
  end
  
  it "can use the 'template' parameter to compare individuals by a specified vector of scores" do
    threeGuys = @myGuesser.generate(3)
    threeGuys[0].scores = {"x1" => 1, "x2" => 2, "x3" => 3}
    threeGuys[1].scores = {"x1" => 2, "x2" => 1, "x3" => 1}
    threeGuys[2].scores = {"x1" => 4, "x2" => 0, "x3" => 2}
    @myNondominatedScreener.generate(threeGuys).length.should == 3
    @myNondominatedScreener.generate(threeGuys,["x1"]).length.should == 1
    @myNondominatedScreener.generate(threeGuys,["x1"]).should include(threeGuys[0])
    @myNondominatedScreener.generate(threeGuys,["x2"]).length.should == 1
    @myNondominatedScreener.generate(threeGuys,["x2"]).should include(threeGuys[2])
    @myNondominatedScreener.generate(threeGuys,["x3"]).length.should == 1
    @myNondominatedScreener.generate(threeGuys,["x3"]).should include(threeGuys[1])
    @myNondominatedScreener.generate(threeGuys,["x1","x3"]).length.should == 2
    @myNondominatedScreener.generate(threeGuys,["x1","x2"]).length.should == 3
    @myNondominatedScreener.generate(threeGuys,["x2","x3"]).length.should == 2
  end
  
  
  it "should use a default 'template' parameter that's the intersection of scores keys in the crowd" do
    twoGuys = @myGuesser.generate(2)
    twoGuys[0].scores = {"x1" => 1, "x2" => 2, "x3" => 3}
    twoGuys[1].scores = {           "x2" => 1,           "x4" => 3}
    @myNondominatedScreener.generate(twoGuys).length.should == 1
    @myNondominatedScreener.generate(twoGuys).should include twoGuys[1]
    @myNondominatedScreener.generate(twoGuys,["x1"]).length.should == 2 # neither dominates on an objectve not shared
  end
  
  it "should return Individuals that belonged to crowd passed in" do
    twoGuys = @myGuesser.generate(2)
    orig_IDs = twoGuys.collect {|dude| dude.object_id}
    twoGuys[0].scores = {"x1" => 1, "x2" => 2, "x3" => 3}
    twoGuys[1].scores = {           "x2" => 1,           "x4" => 3}
    @myNondominatedScreener.generate(twoGuys).length.should == 1
    @myNondominatedScreener.generate(twoGuys).each {|newDude| orig_IDs.should include(newDude.object_id)}
  end
end
require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "nondominated_subset operator" do  
  it "should be a kind of SearchOperator" do
    myScreener = NondominatedSubset.new
    myScreener.should be_a_kind_of(SearchOperator)
  end
  
  it "should produce a set of Individuals when it receives #generate"
  
  it "should use the 'template' parameter to extract a vector of scores"
  
  it "should work no matter what the hash order"
  
  it "should not clone, but simply return references to individuals in the original set"
end
require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "code fragments" do  
  describe "#split" do
    it "should produce an empty list if the block contains nothing"
    
    it "should produce a list with one entry when the block contains an imperative line" 
    
    it "should produce a list of the top-level entries when it contains multiple items"
  end
  
  describe "#points" do
    it "should return the number of lines in the listing"
  end
  
  describe "nth_point" do
    it "should return the root itself when called with n=1"
    
    it "should raise an ArgumentError when called with n not in [1,Code.points]"
    
    it "should return the entirety of the point specified when n>1, including sub-points"
  end
  
  
  describe "types" do
    it "should return an empty list for block-only code"
    
    it "should return the set of the stack names in every literal"
    
    it "should return the set of the stack names in every ERC"
    
    it "should return the set of the stack names in every instruction"
    
    it "should return the set of the stack names in every channel's value"
  end
  
  describe "leaf_count" do
    it "should return a count of the non-block lines in the listing"
  end
  
  describe "point_list" do
    it "should return an array that includes one entry for each point (i.e., line)"
  end
  
  describe "delete_point" do
    it "should delete the entire subtree with the appropriate point number"
  end
  
  describe "replace_point" do
    it "should replace the entire subtree with the appropriate point number"
  end
  
  
end
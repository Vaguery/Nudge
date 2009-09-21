require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "codeblock objects" do
  it "should be a kind of program point" do
    myB = CodeBlock.new()
    myB.should be_a_kind_of(ProgramPoint)
  end
  
  it "should take a listing as a param, default to 'block {}'" do
    sCode = CodeBlock.new()
    sCode.listing.should == "block {}"    
    tCode = CodeBlock.new("block {\n  literal int, 3}")
    tCode.listing.should == "block {\n  literal int, 3}"
  end
  
  it "should [probably] be able to update its own #contents by invoking an external parser somehow"
  
  it "should tidy its listing to be one point per line, with indents and snug braces" 
  
  it "should print the tidy version in response to #inspect"
end


describe "codeblock methods" do
  describe "#split" do
    it "should produce an empty list if the block contains nothing"
    
    it "should produce a list with one entry when the block contains an imperative line" 
    
    it "should produce a list of the top-level entries when it contains multiple items"
  end
  
  describe "#points" do
    it "should return the number of lines in the listing" do
      l1 = ["block {}", "instr thing,value", "channel x1"]
      l1.each do |ll|
        CodeBlock.new(ll).points.should == 1
      end
      
      l2plus = ["block {\n  block {\n    block{}}}", "block {\n  instr thing,value\n  channel x1}"]
      l2plus.each do |ll|
        CodeBlock.new(ll).points.should == 3
      end
    end
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
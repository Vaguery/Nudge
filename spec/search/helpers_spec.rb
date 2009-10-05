require File.join(File.dirname(__FILE__), "./../spec_helper")
include Nudge
include Helpers

describe "a.dominated_by?(b)" do
  {[[17],[10]] => true,
    [[12],[-6]] => true,
    [[7, 18], [15, 4]] => false,
    [[15, 4],[7, 18]] => false,
    [[14, 6],[2, 3]] => true,
    [[15, 15, 14, 12],[6, 6, 8, 5]] => true,
    [[6, 6, 8, 5],[15, 15, 14, 12]] => false
    }.each do |k,v|
      
    it "'#{k[0].inspect}.dominated_by?(#{k[1].inspect})' should actually work and return '#{v}'" do
      k[0].dominated_by?(k[1]).should == v
    end
  end
  
  it "should handle vector length mismatches" do
    lambda{[1,2,3].dominated_by? [4,5]}.should raise_error(ArgumentError)
  end
end


describe "a.domination_classes" do
  before(:each) do
    @testSet = [[29, 8, 24], [10, 20, 4], [0, 13, 6], [22, 0, 27],
              [1, 12, 18], [16, 23, 12], [14, 20, 24], [27, 19, 13], [16, 3, 1], [0, 1, 3]]
  end
  
  it "should return a hash" do
    @testSet.domination_classes.should be_a_kind_of(Hash)
  end
  
  it "should have integers as keys" do
    @testSet.domination_classes.each_key {|k| k.should be_a_kind_of(Fixnum)}
  end
  
  it "should include every element of the calling Array in its keys, and vice versa" do
    result = @testSet.domination_classes
    allVals = []
    result.each {|k,v| allVals.concat v}
    @testSet.each {|x| allVals.should include(x)}
    allVals.each {|x| @testSet.should include(x)}
  end
  
  it "should always have a '0' entry" do
    @testSet.domination_classes.keys.should include(0)
    [[1]].domination_classes.keys.should include(0)
  end
  
  it "should handle vector length mismatches" do
    lambda{[[1],[2,3]].domination_classes}.should raise_error(ArgumentError)
    lambda{[[1,2],[3,4]].domination_classes}.should_not raise_error(ArgumentError)
  end
  
  it "should actually work" do
    expected = { 0=>[[22, 0, 27], [16, 3, 1], [0, 1, 3]],
                 1=>[[10, 20, 4], [0, 13, 6], [1, 12, 18]],
                 2=>[[29, 8, 24]],
                 3=>[[27, 19, 13]],
                 4=>[[16, 23, 12], [14, 20, 24]]}
    result = @testSet.domination_classes
    expected.each {|k,v| result[k].length.should == expected[k].length}
  end
end

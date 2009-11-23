require File.join(File.dirname(__FILE__), "./../spec_helper")
include Nudge

describe "Batches" do
  it "should be a kind of Array" do
    Batch.new.should be_a_kind_of(Array)
  end
  
  it "should raise an exception if a non-Individual is added after initialization" do
    careful = Batch.[](Individual.new("block {}"), Individual.new("block {}"))
    careful.length.should == 2
    
    lambda{careful = Batch.[](12)}.should raise_error(ArgumentError)
    lambda{careful = Batch.[](Individual.new("do int_add"))}.should_not raise_error(ArgumentError)
    
    lambda{careful = Batch.[](Individual.new("do int_add"),12)}.should raise_error(ArgumentError)
    lambda{careful = Batch.[](Individual.new("do int_add"),
      Individual.new("do int_add"))}.should_not raise_error(ArgumentError)
      
    lambda{careful = Batch.new(12)}.should raise_error(ArgumentError)
    lambda{careful = Batch.new(Individual.new("do int_add"))}.should_not raise_error(ArgumentError)
    
    lambda{careful[1] = 991}.should raise_error(ArgumentError)
    lambda{careful[1] = Individual.new("do int_add")}.should_not raise_error(ArgumentError)
    
    lambda{careful << false}.should raise_error(ArgumentError)
    lambda{careful << Individual.new("do int_add")}.should_not raise_error(ArgumentError)
    
  end
end
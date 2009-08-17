require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Leaf" do
  it "should require a value and stackname parameter to be created" do
    lambda{bad = Leaf.new()}.should raise_error(ArgumentError)
    lambda{bad = Leaf.new(:int)}.should raise_error(ArgumentError)
    lambda{bad = Leaf.new(12)}.should raise_error(ArgumentError)
  end
  
  describe "should raise an exception if initialized wrong" do
    it "with no arguments" do
      lambda {bad = Leaf.new}.should raise_error(ArgumentError)
    end
    
    it "with one argument" do
      lambda {bad = Leaf.new(3)}.should raise_error(ArgumentError)
    end
    
    it "with a non-symbol stackname" do
      lambda {bad = Leaf.new( 12, "not_symbol" )}.should 
        raise_error(TypeError, "stackname must be a Symbol")
    end
  end
end


require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "Location" do
  describe "class methods" do
    describe "#locations" do
      it "should be an empty Hash originally" do
        Location.locations.should == {}
      end
    end
  end
  
  describe "names" do
    before(:each) do
      Location.cleanup
    end
    
    it "should have a name" do
      l1 = Location.new("candy_mountain")
      l1.name.should == "candy_mountain"
    end
    it "needs to have a name" do
      lambda{l1 = Location.new}.should raise_error
    end
    it "needs to be a unique name" do
      l1 = Location.new("california")
      lambda{l2 = Location.new("california")}.should raise_error
    end
    it "should register its name in Location#locations upon creation" do
      l1 = Location.new("neverland")
      Location.locations["neverland"].should == l1
    end
  end
  
  describe "network" do
    before(:each) do
      Location.cleanup
    end
    
    it "should have a #flows_into method that adds a #downstream link" do
      l1 = Location.new("bree")
      l2 = Location.new("rivendell")
      l1.flows_into(l2)
      l1.downstream.should be_a_kind_of(Set)
      l1.downstream.should include("rivendell")
    end
  end
end
require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "Location" do
  before(:each) do
    Location.cleanup
  end
  
  describe "class methods" do
    describe "#locations" do
      it "should be an empty Hash originally" do
        Location.locations.should == {}
      end
    end
  end
  
  describe "names" do
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
  
  describe "capacity" do
    it "should have a #capacity attribute that defaults to 100 individuals" do
      l1 = Location.new("candy_mountain")
      l1.capacity.should == 100
    end
    it "should be settable as a second parameter" do
      l1 = Location.new("germany", 912)
      l1.capacity.should == 912
    end
  end
  
  
  describe "network" do
    it "should have a #flows_into method that adds a #downstream link" do
      l1 = Location.new("bree")
      l2 = Location.new("rivendell")
      l1.flows_into(l2)
      l1.downstream.should be_a_kind_of(Set)
      l1.downstream.should include("rivendell")
    end
  end
  
  describe "population" do
    it "should be an Array that's empty initially" do
      l1 = Location.new("spain")
      l1.population.should == []
    end
  end
  
  
  describe "breeding pool" do
    it "should include every Individual in the Location and all downstream locations" do
      l1 = Location.new("bree")
      l2 = Location.new("rivendell")
      dude1 = Individual.new("block {}")
      dude2 = Individual.new("ref x")
      l1.population << dude1
      l2.population << dude2
      l1.breeding_pool.should include(dude1)
      l1.breeding_pool.should_not include(dude2)
      l1.flows_into(l2)
      l1.breeding_pool.should include(dude1)
      l1.breeding_pool.should include(dude2)
      l2.breeding_pool.should_not include(dude1)
      l2.breeding_pool.should include(dude2)
    end
  end
  
  describe "cull_rule" do
    it "should default to 'is population.length > capacity'?" do
      l1 = Location.new("here",1)
      dude1 = Individual.new("block {}")
      l1.population << dude1
      l1.population.length.should == 1
      l1.cull_rule.call.should == false
      l1.population << dude1
      l1.population.length.should == 2
      l1.cull_rule.call.should == true
    end
  end
  
  describe "cull?" do
    it "should be a method that returns a boolean" do
      l1 = Location.new("bree")
      [true,false].should include(l1.cull?)
    end
    it "should invoke self#cull_rule" do
      l1 = Location.new("amondul",1)
      l1.cull_rule.should_receive(:call)
      l1.cull?
    end
  end
end
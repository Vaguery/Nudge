require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "Location" do
  before(:each) do
    Location.cleanup
  end
  
  describe "class methods" do
    describe "#locations" do
      it "should be a Hash" do
        Location.locations.should be_a_kind_of(Hash)
      end
      
      it "should always include :DEAD" do
        Location.locations.should include(:DEAD)
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
  
  describe "add_individual" do
    it "should set the location of the Individual being added to the population to the Location name" do
      l1 = Location.new("mordor")
      dude1 = Individual.new("ref f")
      l1.add_individual dude1
      dude1.location.should == "mordor"
    end
  end
  
  describe "transfer" do
    before(:each) do
      @l1 = Location.new("bree")
      @l2 = Location.new("rivendell")
      @dude1 = Individual.new("block {}")
      @l1.add_individual @dude1
    end
    
    it "should send an Individual from self.population to a different Location" do
      @l1.transfer(0,"rivendell")
      @l1.population.length.should == 0
      @l2.population.should include(@dude1)
    end
    
    it "should change the #location attribute of the moved Individual" do
      @dude1.location.should == "bree"
      @l1.transfer(0,"rivendell")
      @dude1.location.should == "rivendell"
    end
    
    it "should bounds check the popIndex parameter and raise an error if impossible" do
      lambda{@l1.transfer(-20,"rivendell")}.should raise_error(ArgumentError,
        "self#transfer called with index -20")
      lambda{@l1.transfer(8,"rivendell")}.should raise_error(ArgumentError)
      lambda{@l1.transfer(1,"rivendell")}.should_not raise_error(ArgumentError)
    end
    
    it "should name-check the location parameter" do
      lambda{@l1.transfer(1,"nowhere")}.should raise_error(ArgumentError,
        'self#transfer called with nonexistent location "nowhere"')
      lambda{@l1.transfer(1,"rivendell")}.should_not raise_error(ArgumentError)
    end
  end
  
  describe "promote" do    
    describe "to a specific location" do
      before(:each) do
        @l1 = Location.new("bree")
        @l2 = Location.new("rivendell")
        @l3 = Location.new("numenor")
        @l4 = Location.new("washington")
        @l1.flows_into(@l2)
        @l2.flows_into(@l3)
        @l2.flows_into(@l4)
        @dude1 = Individual.new("block {}")
        @l1.add_individual @dude1
      end
      
      it "should raise an exception if the new location isn't immediately downstream" do
        lambda{@l1.promote(0,"numenor")}.should raise_error(ArgumentError,
          '"bree" is not connected to location "numenor"')
        lambda{@l1.promote(0,"rivendell")}.should_not raise_error(ArgumentError)          
      end
      
      it "should select a random downstream destination if none is specified" do
        @l1.promote(0)
        @l2.population.should include(@dude1)
        @l2.promote(0)
        (@l3.population + @l4.population).should include(@dude1)
      end
      
      it "should fail silently if there are no downstream locations" do
        dude2 = Individual.new("do int_add")
        @l4.add_individual(dude2)
        @l4.promote(0)
      end
    end
  end
  
  describe "cull_condition" do
    it "should default to 'is population.length > capacity'?" do
      l1 = Location.new("here",1)
      dude1 = Individual.new("block {}")
      l1.add_individual dude1
      l1.population.length.should == 1
      l1.cull_condition.call.should == false
      l1.add_individual dude1
      l1.population.length.should == 2
      l1.cull_condition.call.should == true
    end
    it "should be settable to some other Proc" do
      l1 = Location.new("here")
      l1.cull_condition = Proc.new {77} #don't do this!
      l1.cull_condition.call.should == 77
    end
  end
  
  describe "cull?" do
    it "should be a method that returns a boolean" do
      l1 = Location.new("bree")
      [true,false].should include(l1.cull?)
    end
    it "should invoke self#cull_rule" do
      l1 = Location.new("amondul",1)
      l1.cull_condition.should_receive(:call)
      l1.cull?
    end
  end
  
  describe "cull_order" do
    it "should return an Array with the Individuals from self#population in it" do
      l1 = Location.new("amondul",1)
      l1.add_individual Individual.new("block {}")
      l1.add_individual Individual.new("ref x")
      l1.cull_order.should be_a_kind_of(Array)
      l1.cull_order[0].should be_a_kind_of(Individual)
      l1.cull_order.length.should == l1.population.length
    end
    
    it "should default to random shuffle order" do
      l1 = Location.new("amondul",1) # default rule
      l1.add_individual Individual.new("block {}")
      l1.add_individual Individual.new("ref x")
      l1.population.should_receive(:shuffle)
      l1.cull_order
    end
  end
  
  describe "actual culling" do
    it "should eventually satisfy the cull? condition" do
      l1 = Location.new("amondul",1) # will have a default cull_order
      lDead = Location.locations[:DEAD]
      l1.add_individual Individual.new("block {}")
      l1.cull?.should == false
      l1.add_individual Individual.new("ref x")
      l1.cull?.should == true
      l1.cull
      l1.cull?.should == false
      lDead.population.length.should == 1
    end
    
    it "should not fire unless self#cull? is true" do
      l1 = Location.new("amondul",1) # will have a default cull_order
      lDead = Location.locations[:DEAD]
      l1.add_individual Individual.new("block {}")
      l1.cull?.should == false
      l1.cull
      l1.population.length.should == 1
    end
  end
  
  describe "generate" do
    describe "generate_rule" do
      before(:each) do
        @loc1 = Location.new("place")
      end
      
      it "should have a default generate_rule that's a Proc 'return an array of one random dude'" do
        @loc1.generate_rule.should be_a_kind_of(Proc)
        gen = @loc1.generate_rule.call
        gen.should be_a_kind_of(Array)
        gen.length.should == 1
        gen[0].should be_a_kind_of(Individual)
      end
      
      it "should work no matter what happens with code generation" do
        pending "FIX the code generation methods"
      end
      
      it "should be associated with each Location"
    end
  end
  
  describe "core cycle" do
    describe "description" do
      it "should run self.generate, then self.promote, then self.cull"
    end
  end
end


describe "DeadLocation" do
  it "should always exist" do
    Location.cleanup
    Location.locations.should include(:DEAD)
    Location.locations[:DEAD].should be_a_kind_of(Location)
    Location.locations[:DEAD].should be_a_kind_of(DeadLocation)
  end
  
  it "should have no capacity" do
    Location.locations[:DEAD].capacity.should == nil
  end
end
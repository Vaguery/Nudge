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
      loc1 = Location.new("candy_mountain")
      loc1.name.should == "candy_mountain"
    end
    it "needs to have a name" do
      lambda{loc1 = Location.new}.should raise_error
    end
    it "needs to be a unique name" do
      loc1 = Location.new("california")
      lambda{loc2 = Location.new("california")}.should raise_error
    end
    it "should register its name in Location#locations upon creation" do
      loc1 = Location.new("neverland")
      Location.locations["neverland"].should == loc1
    end
  end
  
  
  describe "capacity" do
    it "should have a #capacity attribute that defaults to 100 individuals" do
      loc1 = Location.new("candy_mountain")
      loc1.capacity.should == 100
    end
    it "should be settable as a second parameter" do
      loc1 = Location.new("germany", 912)
      loc1.capacity.should == 912
    end
  end
  
  
  describe "network" do
    it "should have a #flows_into method that adds a #downstream link" do
      loc1 = Location.new("bree")
      loc2 = Location.new("rivendell")
      loc1.flows_into(loc2)
      loc1.downstream.should be_a_kind_of(Set)
      loc1.downstream.should include("rivendell")
    end
  end
  
  
  describe "population" do
    it "should be an Array that's empty initially" do
      loc1 = Location.new("spain")
      loc1.population.should == []
    end
  end
  
  
  describe "breeding pool" do
    it "should include every Individual in the Location and all downstream locations" do
      loc1 = Location.new("bree")
      loc2 = Location.new("rivendell")
      dude1 = Individual.new("block {}")
      dude2 = Individual.new("ref x")
      loc1.population << dude1
      loc2.population << dude2
      loc1.breeding_pool.should include(dude1)
      loc1.breeding_pool.should_not include(dude2)
      loc1.flows_into(loc2)
      loc1.breeding_pool.should include(dude1)
      loc1.breeding_pool.should include(dude2)
      loc2.breeding_pool.should_not include(dude1)
      loc2.breeding_pool.should include(dude2)
    end
  end
  
  
  describe "add_individual" do
    it "should set the location of the Individual being added to the population to the Location name" do
      loc1 = Location.new("mordor")
      dude1 = Individual.new("ref f")
      loc1.add_individual dude1
      dude1.location.should == "mordor"
    end
  end
  
  
  describe "transfer" do
    before(:each) do
      @loc1 = Location.new("bree")
      @loc2 = Location.new("rivendell")
      @dude1 = Individual.new("block {}")
      @loc1.add_individual @dude1
    end
    
    it "should send an Individual from self.population to a different Location" do
      @loc1.transfer(0,"rivendell")
      @loc1.population.length.should == 0
      @loc2.population.should include(@dude1)
    end
    
    it "should change the #location attribute of the moved Individual" do
      @dude1.location.should == "bree"
      @loc1.transfer(0,"rivendell")
      @dude1.location.should == "rivendell"
    end
    
    it "should bounds check the popIndex parameter and raise an error if impossible" do
      lambda{@loc1.transfer(-20,"rivendell")}.should raise_error(ArgumentError,
        "self#transfer called with index -20")
      lambda{@loc1.transfer(8,"rivendell")}.should raise_error(ArgumentError)
      lambda{@loc1.transfer(1,"rivendell")}.should_not raise_error(ArgumentError)
    end
    
    it "should name-check the location parameter" do
      lambda{@loc1.transfer(1,"nowhere")}.should raise_error(ArgumentError,
        'self#transfer called with nonexistent location "nowhere"')
      lambda{@loc1.transfer(1,"rivendell")}.should_not raise_error(ArgumentError)
    end
  end
  
  
  describe "promote" do    
    describe "to a specific location" do
      before(:each) do
        @loc1 = Location.new("bree")
        @loc2 = Location.new("rivendell")
        @loc3 = Location.new("numenor")
        @loc4 = Location.new("washington")
        @loc1.flows_into(@loc2)
        @loc2.flows_into(@loc3)
        @loc2.flows_into(@loc4)
        @dude1 = Individual.new("block {}")
        @loc1.add_individual @dude1
      end
      
      it "should raise an exception if the new location isn't immediately downstream" do
        lambda{@loc1.promote(0,"numenor")}.should raise_error(ArgumentError,
          '"bree" is not connected to location "numenor"')
        lambda{@loc1.promote(0,"rivendell")}.should_not raise_error(ArgumentError)          
      end
      
      it "should select a random downstream destination if none is specified" do
        @loc1.promote(0)
        @loc2.population.should include(@dude1)
        @loc2.promote(0)
        (@loc3.population + @loc4.population).should include(@dude1)
      end
      
      it "should fail silently if there are no downstream locations" do
        dude2 = Individual.new("do int_add")
        @loc4.add_individual(dude2)
        @loc4.promote(0)
      end
    end
  end
  
  
  describe "promote?" do
    before(:each) do
      @loc1 = Location.new("bree")
      @loc2 = Location.new("rivendell")
      @loc3 = Location.new("numenor")
      @loc4 = Location.new("washington")
      @loc1.flows_into(@loc2)
      @loc2.flows_into(@loc3)
      @loc2.flows_into(@loc4)
      @dude1 = Individual.new("block {}")
      @loc1.add_individual @dude1
    end
    
    it "should default to 'false'" do
      @loc1.promote?(@loc1.population[0]).should == false
    end
    
    it "should refer to self.promotion_rule to make the decision" do
      @loc1.promotion_rule.stub(:call).and_return(999)
      @loc1.promote?(@loc1.population[0]).should == 999
    end
  end
  
  
  describe "cull_rule" do
    it "should default to 'is population.length > capacity'?" do
      loc1 = Location.new("here",1)
      dude1 = Individual.new("block {}")
      loc1.add_individual dude1
      loc1.population.length.should == 1
      loc1.cull_rule.call.should == false
      loc1.add_individual dude1
      loc1.population.length.should == 2
      loc1.cull_rule.call.should == true
    end
    
    it "should be settable to some other Proc" do
      loc1 = Location.new("here")
      loc1.cull_rule = Proc.new {77} #don't do this!
      loc1.cull_rule.call.should == 77
    end
  end
  
  
  describe "cull?" do
    it "should be a method that returns a boolean" do
      loc1 = Location.new("bree")
      [true,false].should include(loc1.cull?)
    end
    
    it "should invoke self#cull_rule" do
      loc1 = Location.new("amondul",1)
      loc1.cull_rule.should_receive(:call)
      loc1.cull?
    end
  end
  
  
  describe "cull_order" do
    it "should return an Array with the Individuals from self#population in it" do
      loc1 = Location.new("amondul",1)
      loc1.add_individual Individual.new("block {}")
      loc1.add_individual Individual.new("ref x")
      loc1.cull_order.should be_a_kind_of(Array)
      loc1.cull_order[0].should be_a_kind_of(Individual)
      loc1.cull_order.length.should == loc1.population.length
    end
    
    it "should default to random shuffle order" do
      loc1 = Location.new("amondul",1) # default rule
      loc1.add_individual Individual.new("block {}")
      loc1.add_individual Individual.new("ref x")
      loc1.population.should_receive(:shuffle)
      loc1.cull_order
    end
  end
  
  
  describe "actual culling" do
    it "should eventually satisfy the cull? condition" do
      loc1 = Location.new("amondul",1) # will have a default cull_order
      lDead = Location.locations[:DEAD]
      loc1.add_individual Individual.new("block {}")
      loc1.cull?.should == false
      loc1.add_individual Individual.new("ref x")
      loc1.cull?.should == true
      loc1.cull
      loc1.cull?.should == false
      lDead.population.length.should == 1
    end
    
    it "should not fire unless self#cull? is true" do
      loc1 = Location.new("amondul",1) # will have a default cull_order
      lDead = Location.locations[:DEAD]
      loc1.add_individual Individual.new("block {}")
      loc1.cull?.should == false
      loc1.cull
      loc1.population.length.should == 1
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
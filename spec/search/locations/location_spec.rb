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
  
  
  describe "settings" do
    it "should have a #settings attribute, where active instructions, variable names and types are listed" do
      loc1 = Location.new("place")
      loc1.settings.should_not == nil
      loc1.settings.should be_a_kind_of(Settings)
    end
    
    it "should default to all defined Instructions" do
      Location.new("place").settings.instructions.should == Instruction.all_instructions
    end
    
    it "should default to no variables defined" do
      Location.new("place").settings.references.should == []
    end
    
    it "should default to the Push types (not all types)" do
      Location.new("place").settings.types.should == NudgeType.push_types
    end
    
    it "should be possible to pass in initial Array of active Instructions" do
      loc = Location.new("p1", 4, :instructions => [IntAddInstruction])
      loc.settings.instructions.should == [IntAddInstruction]
      Location.new("p2", 4, :types => [IntType]).settings.types.should == [IntType]
      Location.new("p3", 4, :references => ["x1"]).settings.references.should == ["x1"]
      lambda{Location.new("p4", 4, :random_crap => ["whatever"])}.should_not raise_error
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
          '"bree" is not connected to "numenor"')
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
        lambda{@loc4.promote(0)}.should_not raise_error
        @loc4.promote(0)
        @loc4.population.length.should == 1
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
  
  
  describe "review_and_promote" do
    before(:each) do
      @loc1 = Location.new("bree")
      @loc2 = Location.new("rivendell")
      @loc1.flows_into(@loc2)
      @dude1 = Individual.new("block {}")
      @loc1.add_individual @dude1
    end
    
    it "should apply self.promote? to all members of the population" do
      @loc1.should_receive(:promote?).once
      @loc1.review_and_promote
      
      @loc1.add_individual @dude1 # again! Don't actually ever do this...
      @loc1.should_receive(:promote?).twice
      @loc1.review_and_promote
    end
    
    it "should only send the ones for whom #promote? is true" do
      @loc1.should_not_receive(:promote)
      @loc1.review_and_promote
    end
    
    it "should however actually lose the ones for whom #promote? is true" do
      @loc2.population.length.should == 0
      theGuy = @loc1.population[0]
      @loc1.promotion_rule = Proc.new {|dude| true}
      @loc1.review_and_promote
      @loc2.population.length.should == 1
      @loc2.population.should include(theGuy)
    end
    
    it "should only move the ones for whom #promote? is true" do
      dude2 = Individual.new("do something")
      @loc1.add_individual dude2
      @loc1.promotion_rule = Proc.new {|dude| dude.genome.include?("something")}
      @loc1.review_and_promote
      
      @loc1.population.length.should == 1
      @loc2.population.length.should == 1
      @loc2.population.should_not include(@dude1)
      @loc1.population.should include(@dude1)
      @loc2.population.should include(dude2)
      @loc1.population.should_not include(dude2)
    end
  end
  
  
  describe "cull_trigger" do
    it "should default to 'is population.length > capacity'?" do
      loc1 = Location.new("here",1)
      dude1 = Individual.new("block {}")
      loc1.add_individual dude1
      loc1.population.length.should == 1
      loc1.cull_trigger.call.should == false
      loc1.add_individual dude1
      loc1.population.length.should == 2
      loc1.cull_trigger.call.should == true
    end
    
    it "should be settable to some other Proc" do
      loc1 = Location.new("here")
      loc1.cull_trigger = Proc.new {77} #don't do this!
      loc1.cull_trigger.call.should == 77
    end
  end
  
  
  describe "cull?" do
    it "should be a method that returns a boolean" do
      loc1 = Location.new("bree")
      [true,false].should include(loc1.cull?)
    end
    
    it "should invoke self#cull_trigger" do
      loc1 = Location.new("amondul",1)
      loc1.cull_trigger.should_receive(:call)
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
      loc1.review_and_cull
      loc1.cull?.should == false
      lDead.population.length.should == 1
    end
    
    it "should not fire unless self#cull? is true" do
      loc1 = Location.new("amondul",1) # will have a default cull_order
      lDead = Location.locations[:DEAD]
      loc1.add_individual Individual.new("block {}")
      loc1.cull?.should == false
      loc1.review_and_cull
      loc1.population.length.should == 1
    end
  end
  
  
  describe "Location#generate" do
    before(:each) do
      @loc1 = Location.new("here",1)
    end
    
    it "should access the breeding_pool when called" do
      @loc1.should_receive(:breeding_pool).and_return(["mock filler"])
      @loc1.generate()
    end
    
    it "should invoke #generate_rule" do
      @loc1.generate_rule.should_receive(:call).and_return(["some dude"])
      @loc1.generate
    end
    
    it "should end up with the results of generate_rule merged into its population" do
      @loc1.generate_rule.should_receive(:call).and_return(["some dude"])
      @loc1.generate
      @loc1.population.should include("some dude")
      
      @loc1.generate_rule.should_receive(:call).and_return(["other dude"])
      @loc1.generate
      @loc1.population.length.should == 2
    end
  end
  
  
  describe "generate_rule" do
    before(:each) do
      @loc1 = Location.new("here",1)
      @loc1.settings.types = [IntType]
    end
    
    it "should take one parameter" do
      @loc1.generate_rule.arity.should == 1
    end
    
    # detailed validation of inputs and output is a postponed story
    
    it "should return an array of individuals" do
      newDudes = @loc1.generate_rule.call
      newDudes.should be_a_kind_of(Array)
      newDudes.each {|i| i.should be_a_kind_of(Individual)}
    end
  end
  
  
  describe "core_cycle" do
    before(:each) do
      @loc1 = Location.new("here",1)
      @loc2 = Location.new("there",1)
      @loc1.flows_into(@loc2)
      @loc1.settings.types = [IntType]
      @loc2.settings.types = [IntType]
    end
    
    it "should invoke #generate once" do
      @loc1.should_receive(:generate)
      @loc1.core_cycle
    end
    
    it "should invoke #review_and_promote" do
      @loc1.should_receive(:review_and_promote)
      @loc1.core_cycle
    end
    
    it "should invoke #cull once" do
      @loc1.should_receive(:review_and_cull).once
      @loc1.core_cycle
      # there is one random guy here with the default generate rule
    end
    
    it "should cull only enough to make the cull_trigger false" do
      @loc1.add_individual(Individual.new("do die"))
      @loc1.population.length.should == 1
      
      @loc1.core_cycle #this adds a new random dude AND CULLS HIM (capacity = 1)
      @loc1.population.length.should == 1
      Location.locations[:DEAD].population.length.should == 1
      
      @loc1.capacity = 2
      @loc1.core_cycle #this adds a new random dude AND HE'S FINE (capacity = 2)
      @loc1.population.length.should == 2
      Location.locations[:DEAD].population.length.should == 1
      
      @loc1.cull_trigger.should_receive(:call).and_return(true, true, false)
      @loc1.should_receive(:cull_order).and_return(@loc1.population)
      @loc1.core_cycle  #now we have three dudes, two of which will die
      @loc1.population.length.should == 1
      Location.locations[:DEAD].population.length.should == 3
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
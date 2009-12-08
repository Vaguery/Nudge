require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "Station" do
  before(:each) do
    Station.cleanup
  end
  
  
  describe "class methods" do
    describe "#stations" do
      it "should be a Hash" do
        Station.stations.should be_a_kind_of(Hash)
      end
      
      it "should always include :DEAD" do
        Station.stations.should include(:DEAD)
      end
    end
  end
  
  
  describe "names" do
    it "should have a name" do
      loc1 = Station.new("candy_mountain")
      loc1.name.should == "candy_mountain"
    end
    it "needs to have a name" do
      lambda{loc1 = Station.new}.should raise_error
    end
    it "needs to be a unique name" do
      loc1 = Station.new("california")
      lambda{loc2 = Station.new("california")}.should raise_error
    end
    it "should register its name in Station#stations upon creation" do
      loc1 = Station.new("neverland")
      Station.stations["neverland"].should == loc1
    end
    
    it "should collect all created stations" do
      Station.stations.length.should == 1
      alpha = Station.new("alpha")
      Station.stations.length.should == 2
      beta = Station.new("beta")
      Station.stations.length.should == 3
      Station.stations.keys.should == [:DEAD,"alpha", "beta"]
    end
  end
  
  
  describe "capacity" do
    it "should have a #capacity parameter that defaults to 100 individuals" do
      loc1 = Station.new("candy_mountain")
      loc1.capacity.should == 100
    end
    it "should be settable as a second parameter" do
      loc1 = Station.new("germany", capacity:912)
      loc1.capacity.should == 912
    end
  end
  
  
  describe "settings" do
    it "should have a #settings attribute, where active instructions, variable names and types are listed" do
      loc1 = Station.new("place")
      loc1.settings.should_not == nil
      loc1.settings.should be_a_kind_of(InterpreterSettings)
    end
    
    it "should default to all defined Instructions" do
      Station.new("place").settings.instructions.should == Instruction.all_instructions
    end
    
    it "should default to no variables defined" do
      Station.new("place").settings.references.should == []
    end
    
    it "should default to the Push types (not all types)" do
      Station.new("place").settings.types.should == NudgeType.push_types
    end
    
    it "should be possible to pass in initial Array of active Instructions" do
      loc = Station.new("p1", instructions: [IntAddInstruction])
      loc.settings.instructions.should == [IntAddInstruction]
      Station.new("p2", capacity: 4, :types => [IntType]).settings.types.should == [IntType]
      Station.new("p3", capacity: 4, :references => ["x1"]).settings.references.should == ["x1"]
      lambda{Station.new("p4", capacity: 4, :random_crap => ["whatever"])}.should_not raise_error
    end
  end
  
  
  describe "network" do
    it "should have a #flows_into method that adds a #downstream link" do
      loc1 = Station.new("bree")
      loc2 = Station.new("rivendell")
      loc1.flows_into(loc2)
      loc1.downstream.should be_a_kind_of(Set)
      loc1.downstream.should include("rivendell")
    end
  end
  
  
  describe "population" do
    it "should be an Array that's empty initially" do
      loc1 = Station.new("spain")
      loc1.population.should == []
    end
  end
  
  describe "persistent store (database)" do
    it "should have a URL for a couchDB (with name)" do
      loc1 = Station.new("spain", database:"http://localhost:5984")
      loc1.database.should == "http://localhost:5984/spain"
    end
  end
  
  describe "breeding pool" do
    it "should include every Individual in the Station and all downstream stations" do
      loc1 = Station.new("bree")
      loc2 = Station.new("rivendell")
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
    it "should set the station of the Individual being added to the population to the Station name" do
      loc1 = Station.new("mordor")
      dude1 = Individual.new("ref f")
      loc1.add_individual dude1
      dude1.station.should == loc1
    end
    
    it "should be a private method"
  end
  
  
  describe "transfer" do
    before(:each) do
      @loc1 = Station.new("bree")
      @loc2 = Station.new("rivendell")
      @dude1 = Individual.new("block {}")
      @loc1.add_individual @dude1
    end
    
    it "should send an Individual from self.population to a different Station" do
      @loc1.transfer(0,"rivendell")
      @loc1.population.length.should == 0
      @loc2.population.should include(@dude1)
    end
    
    it "should change the #station attribute of the moved Individual" do
      @dude1.station.should == @loc1
      @loc1.transfer(0,"rivendell")
      @dude1.station.should == @loc2
    end
    
    it "should bounds check the popIndex parameter and raise an error if impossible" do
      lambda{@loc1.transfer(-20,"rivendell")}.should raise_error(ArgumentError,
        "self#transfer called with index -20")
      lambda{@loc1.transfer(8,"rivendell")}.should raise_error(ArgumentError)
      lambda{@loc1.transfer(1,"rivendell")}.should_not raise_error(ArgumentError)
    end
    
    it "should name-check the station parameter" do
      lambda{@loc1.transfer(1,"nowhere")}.should raise_error(ArgumentError,
        'self#transfer called with nonexistent station "nowhere"')
      lambda{@loc1.transfer(1,"rivendell")}.should_not raise_error(ArgumentError)
    end
  end
  
  
  describe "promote" do    
    describe "to a specific station" do
      before(:each) do
        @loc1 = Station.new("bree")
        @loc2 = Station.new("rivendell")
        @loc3 = Station.new("numenor")
        @loc4 = Station.new("washington")
        @loc1.flows_into(@loc2)
        @loc2.flows_into(@loc3)
        @loc2.flows_into(@loc4)
        @dude1 = Individual.new("block {}")
        @loc1.add_individual @dude1
      end
      
      it "should raise an exception if the new station isn't immediately downstream" do
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
      
      it "should fail silently if there are no downstream stations" do
        dude2 = Individual.new("do int_add")
        @loc4.add_individual(dude2)
        lambda{@loc4.promote(0)}.should_not raise_error
        @loc4.promote(0)
        @loc4.population.length.should == 1
      end
    end
  end
  
  describe "promotion_rule" do
    it "should default to false"
    it "should be settable via a parameter with that name"
  end
  
  
  describe "promote?" do
    before(:each) do
      @loc1 = Station.new("bree")
      @loc2 = Station.new("rivendell")
      @loc3 = Station.new("numenor")
      @loc4 = Station.new("washington")
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
      @loc1 = Station.new("bree")
      @loc2 = Station.new("rivendell")
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
  
  
  describe "cull_check" do
    it "should default to 'is population.length > capacity'?" do
      loc1 = Station.new("here", capacity: 1)
      dude1 = Individual.new("block {}")
      loc1.add_individual dude1
      loc1.population.length.should == 1
      loc1.cull_check.call.should == false
      loc1.add_individual dude1
      loc1.population.length.should == 2
      loc1.cull_check.call.should == true
    end
    
    it "should be settable to some other Proc" do
      loc1 = Station.new("here", cull_check: Proc.new {77})
      loc1.cull_check.call.should == 77
    end
  end
  
  
  describe "cull?" do
    it "should be a method that returns a boolean" do
      loc1 = Station.new("bree")
      [true,false].should include(loc1.cull?)
    end
    
    it "should invoke self#cull_check" do
      loc1 = Station.new("amondul", capacity:1)
      loc1.cull_check.should_receive(:call)
      loc1.cull?
    end
  end
  
  
  describe "cull" do
    it "should invoke the cull_rule if cull? is true"
    
    it "should not invoke cull_rule if cull? is false"
    
    it "should invoke cull_rule repeatedly until cull? is false"
    
    it "should return an Array with the Individuals from self#population in it" do
      pending
      loc1 = Station.new("amondul", capacity:1)
      loc1.add_individual Individual.new("block {}")
      loc1.add_individual Individual.new("ref x")
      loc1.cull_order.should be_a_kind_of(Array)
      loc1.cull_order[0].should be_a_kind_of(Individual)
      loc1.cull_order.length.should == loc1.population.length
    end
    
    it "should default to random shuffle order" do
      pending
      loc1 = Station.new("amondul", capacity:1) # default rule
      loc1.add_individual Individual.new("block {}")
      loc1.add_individual Individual.new("ref x")
      loc1.population.should_receive(:shuffle)
      loc1.cull_order
    end
  end
  
  
  describe "actual culling" do
    it "should eventually satisfy the cull? condition" do
      loc1 = Station.new("amondul",capacity:1) # will have a default cull_order
      lDead = Station.stations[:DEAD]
      loc1.add_individual Individual.new("block {}")
      loc1.cull?.should == false
      loc1.add_individual Individual.new("ref x")
      loc1.cull?.should == true
      
      pending "This needs rewriting"
      loc1.review_and_cull
      loc1.cull?.should == false
      lDead.population.length.should == 1
    end
    
    it "should not fire unless self#cull? is true" do
      loc1 = Station.new("amondul",capacity:1) # will have a default cull_order
      lDead = Station.stations[:DEAD]
      loc1.add_individual Individual.new("block {}")
      loc1.cull?.should == false
      loc1.review_and_cull
      loc1.population.length.should == 1
    end
  end
  
  
  describe "Station#generate" do
    before(:each) do
      @loc1 = Station.new("here",capacity:1)
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
      @loc1 = Station.new("here",capacity:1)
      @loc1.settings.types = [IntType]
    end
    
    it "should be possible to override the default by passing a param"
    
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
      @loc1 = Station.new("here",capacity:1)
      @loc2 = Station.new("there",capacity:1)
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
      
      pending "This needs rewriting"
      @loc1.core_cycle #this adds a new random dude AND CULLS HIM (capacity = 1)
      @loc1.population.length.should == 1
      Station.stations[:DEAD].population.length.should == 1
      
      @loc1.capacity = 2
      @loc1.core_cycle #this adds a new random dude AND HE'S FINE (capacity = 2)
      @loc1.population.length.should == 2
      Station.stations[:DEAD].population.length.should == 1
      
      @loc1.cull_check.should_receive(:call).and_return(true, true, false)
      @loc1.should_receive(:cull_order).and_return(@loc1.population)
      @loc1.core_cycle  #now we have three dudes, two of which will die
      @loc1.population.length.should == 1
      Station.stations[:DEAD].population.length.should == 3
    end
  end
end




describe "DeadStation" do
  it "should always exist" do
    Station.cleanup
    Station.stations.should include(:DEAD)
    Station.stations[:DEAD].should be_a_kind_of(Station)
    Station.stations[:DEAD].should be_a_kind_of(DeadStation)
  end
  
  it "should have no capacity" do
    Station.stations[:DEAD].capacity.should == nil
  end
end
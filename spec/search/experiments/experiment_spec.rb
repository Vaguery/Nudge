require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge



describe "Experiment" do
  before(:each) do
    @exp = Experiment.new
  end
  
  it "should have a name defaulting to 'default_experiment'" do
    @exp.name.should == 'default_experiment'
    Experiment.new(name: "regress").name.should == "regress"
  end
  
  describe "#config object" do
    it "should have a #config attribute, of class Config" do
      @exp.config.should_not == nil
      @exp.config.should be_a_kind_of(Nudge::Config)
    end
  end
  
  it "should have an #instructions Array, defaulting to all of them" do
    (@exp.instructions.sort_by {|i| i.to_s}).should == (Instruction.all_instructions.sort_by {|i| i.to_s})
  end
  
  it "should have a #types Array, defaulting to [BoolType, FloatType, IntType]" do
    @exp.types.should == [BoolType, FloatType, IntType]
  end
  
  
  describe "stations" do
    before(:each) do
      @exp = Experiment.new
      Station.cleanup
    end
    
    it "should have an empty hash of Station names" do
      @exp.station_names.should == []
    end
    
    describe "build_station" do
      it "should create a new Station instance, and add it to its own #stations list" do
        @exp.build_station("wondrous")
        @exp.station_names.should include("wondrous")
        Station.stations.keys.should include("wondrous")
      end
      
      it "should use the parameters passed in" do
        @exp.build_station("wondrous", capacity:12)
        Station.stations["wondrous"].capacity.should == 12
      end
    end
    
    describe "connect_stations" do
      it "should create a #flows_into connection between two Stations when called" do
        @exp.build_station("alphaville")
        @exp.build_station("beta_2")
        Station.stations["alphaville"].downstream.should be_empty
        Station.stations["beta_2"].downstream.should be_empty
        @exp.connect_stations("alphaville", "beta_2")
        Station.stations["alphaville"].downstream.should include("beta_2")
      end
      
      it "should raise an ArgumentError if either name does not yet exist in the Experiment" do
        @exp.build_station("alphaville")
        @exp.build_station("beta_2")
        lambda{@exp.connect_stations("alphaville", "beta_2")}.should_not raise_error(ArgumentError)
        lambda{@exp.connect_stations("cygnus", "beta_2")}.should raise_error(ArgumentError)
        lambda{@exp.connect_stations("alphaville", "cygnus")}.should raise_error(ArgumentError)
      end
    end
  end
  
  describe "objectives" do
    it "should have a library of 'permitted' objectives, an empty hash to begin with" do
      @exp.objectives.should == {}
    end
    
    describe "build_objective" do
      it "should create a new Evaluator instance, and add it to its own #stations list" do
        
      end
    end
    
  end
  
  describe "databases" do
    it "should have a couchDB path" do
      @exp.data_path.should == "../data"
      Experiment.new(:data_path => "../somewhere_else").data_path.should == '../somewhere_else'
    end
  end
  
end
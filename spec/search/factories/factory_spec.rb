require File.join(File.dirname(__FILE__), "./../../spec_helper")
require 'fakeweb'
include Nudge



describe "Factory" do
  before(:each) do
    @my_factory = Factory.new
  end
  
  it "should have a name defaulting to 'default_factory'" do
    @my_factory.name.should == 'default_factory'
    Factory.new(name: "regress").name.should == "regress"
  end
  
  describe "#config object" do
    it "should have a #config attribute, of class Config" do
      @my_factory.config.should_not == nil
      @my_factory.config.should be_a_kind_of(Nudge::Config)
    end
  end
  
  it "should have an #instructions Array, defaulting to all of them" do
    (@my_factory.instructions.sort_by {|i| i.to_s}).should == (Instruction.all_instructions.sort_by {|i| i.to_s})
  end
  
  it "should have a #types Array, defaulting to [BoolType, FloatType, IntType]" do
    @my_factory.types.should == [BoolType, FloatType, IntType]
  end
  
  
  describe "stations" do
    before(:each) do
      @my_factory = Factory.new
      Station.cleanup
    end
    
    it "should have an empty hash of Station names" do
      @my_factory.station_names.should == []
    end
    
    describe "build_station" do
      it "should create a new Station instance, and add it to its own #stations list" do
        @my_factory.build_station("wondrous")
        @my_factory.station_names.should include("wondrous")
        Station.stations.keys.should include("wondrous")
      end
      
      it "should use the parameters passed in" do
        @my_factory.build_station("wondrous", capacity:12)
        Station.stations["wondrous"].capacity.should == 12
      end
    end
    
    describe "connect_stations" do
      it "should create a #flows_into connection between two Stations when called" do
        @my_factory.build_station("alphaville")
        @my_factory.build_station("beta_2")
        Station.stations["alphaville"].downstream.should be_empty
        Station.stations["beta_2"].downstream.should be_empty
        @my_factory.connect_stations("alphaville", "beta_2")
        Station.stations["alphaville"].downstream.should include("beta_2")
      end
      
      it "should raise an ArgumentError if either name does not yet exist in the Factory" do
        @my_factory.build_station("alphaville")
        @my_factory.build_station("beta_2")
        lambda{@my_factory.connect_stations("alphaville", "beta_2")}.should_not raise_error(ArgumentError)
        lambda{@my_factory.connect_stations("cygnus", "beta_2")}.should raise_error(ArgumentError)
        lambda{@my_factory.connect_stations("alphaville", "cygnus")}.should raise_error(ArgumentError)
      end
    end
  end
  
  describe "objectives" do
    it "should have a library of 'permitted' objectives, an empty hash to begin with" do
      @my_factory.objectives.should == {}
    end
    
  end
  
  describe "databases" do
    it "should have a couchDB URL attribute, via parameter setting or default" do
      @my_factory.couch_url.should == "http://localhost:5984"
      otherplace = 'http://vagueserver.com:99999'
      Factory.new(:couch_url => otherplace).couch_url.should == otherplace
    end
    
    it "should have a method to check that couchDB is accessible" do
      FakeWeb.register_uri(:get, "http://localhost:5984", :status => ["200", "OK"])
      @my_factory.couch_url = "http://localhost:5984"
      @my_factory.couch_live?.should == true
            
      FakeWeb.register_uri(:get, "http://localhost:99999", :exception => SocketError)
      @my_factory.couch_url = "http://localhost:99999"
      @my_factory.couch_live?.should == false
    end
  end
  
end
require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge



describe "Experiment" do
  before(:each) do
    @exp = Experiment.new
  end
  
  it "should have a name defaulting to 'default_experiment'" do
    @exp.name.should == 'default_experiment'
    Experiment.new(:name => "regress").name.should == "regress"
  end
  
  it "should have a #config_path attribute that defaults to ../config" do
    @exp.config_path.should == "../config"
    Experiment.new(:config_path => "../somewhere_else").config_path.should == '../somewhere_else'
  end
  
  describe "stations" do
    it "should have an empty array of Stations" do
      @exp.stations.should == []
    end
  end
  
  
  describe "databases" do
    it "should have a couchDB path" do
      @exp.data_path.should == "../data"
      Experiment.new(:data_path => "../somewhere_else").data_path.should == '../somewhere_else'
    end
  end
  
end
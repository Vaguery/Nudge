require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge



describe "config.rb" do
end



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
  
  it "should read config.rb"
  it "should create one or more Stations"
  it "should create instances of a number of Evaluators"
  it "should have a couchDB connection"
  it "should have a core Settings instance"
  it "should launch the web app"
  it "should launch the search app"
end
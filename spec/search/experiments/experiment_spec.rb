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
    it "should have an empty array of Stations" do
      @exp.stations.should == []
    end
  end
  
  describe "objectives" do
    it "should have a library of 'permitted' objectives, an empty hash to begin with" do
      @exp.objectives.should == {}
    end
  end
  
  describe "databases" do
    it "should have a couchDB path" do
      @exp.data_path.should == "../data"
      Experiment.new(:data_path => "../somewhere_else").data_path.should == '../somewhere_else'
    end
  end
  
end
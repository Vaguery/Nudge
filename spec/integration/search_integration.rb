require File.dirname(__FILE__) + '/../spec_helper'
include Nudge

describe "Couch Writing" do
  before(:each) do
    Station.cleanup
    time_now = Time.now
    Time.stub!(:now).and_return(time_now)
    time_now.stub!(:to_i).and_return(999999)
    
    @dude = Individual.new("block {}")
    @homeBase = Station.new("away")
    @dude.scores = {"happiness" => 54}
    @homeBase.add_individual(@dude)
    
    @theActualDB = CouchRest.database!(@homeBase.database)
  end
  
  after(:each) do
    @theActualDB.delete!
  end
  
  
  it "should write its data to the database for its Station" do
    @dude.write
    @dude.id.should_not == nil
  end

  it "should write the genome" do
    @dude.write
    id = @dude.id
    foundThing = @theActualDB.get(id)
    foundThing["genome"].should == @dude.genome
  end
  
  it "should write the scores hash" do
    @dude.write
    id = @dude.id
    foundThing = @theActualDB.get(id)
    foundThing["scores"].should == @dude.scores
  end

  it "should write the birthmoment of the individual" do
    @dude.write
    id = @dude.id
    foundThing = @theActualDB.get(id)
    foundThing["creation_time"].should == 999999
  end
end

describe "Individual#find in Couch" do
  before(:each) do
    @couch_url = "http://localhost:5984/slash"
    @theActualDB = CouchRest.database!(@couch_url)
    @theData = {"genome"=>"do int_add", "scores"=> {"happiness"=>99}, "creation_time"=> 10000}
    theResult = @theActualDB.save_doc(@theData)
    @oldID = theResult["id"]
  end
  
  it "should return an Individual from a couch_url with a given ID" do
    dude = Individual.get(@couch_url,@oldID)
    dude.id.should == @oldID
    dude.genome.should == @theData["genome"]
    dude.scores.should == @theData["scores"]
    dude.timestamp.should == @theData["creation_time"]
  end
end

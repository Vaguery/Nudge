require File.dirname(__FILE__) + '/../spec_helper'
include Nudge

describe "Couch Writing" do
  before(:each) do
    Station.cleanup
    
    @dude = Individual.new("block {}")
    @homeBase = Station.new("away")
    @dude.scores = {"happiness" => 99}
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
  
  # database should have its genome afterwards
  # when you find the dude again, it's pre and post genome should be ==
  
  it "should write the scores hash"
  # when you find the dude again, it's pre and post scores should be ==

  it "should write the Time.now"
  
end

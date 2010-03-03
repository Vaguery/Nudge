#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
require "fakeweb"
include Nudge

describe "Individual" do
  
  describe "initialization" do
    before(:each) do
      @i1 = Individual.new("value «bool»\n«bool» false")
    end
    
    it "should accept a string OR a NudgeProgram as an initialization parameter" do
      lambda{Individual.new("some crap")}.should_not raise_error
      lambda{Individual.new("block {}")}.should_not raise_error
      lambda{Individual.new("")}.should_not raise_error
      
      lambda{Individual.new(NudgeProgram.new("block {}"))}.should_not raise_error
      lambda{Individual.new(NudgeProgram.new(""))}.should_not raise_error
      
      lambda{Individual.new(8812)}.should raise_error
      lambda{Individual.new(NudgeProgram.new())}.should raise_error
      lambda{Individual.new([1,2,3])}.should raise_error
    end
    
    it "should have a program attribute, which is a NudgeProgram object" do
      @i1.program.should be_a_kind_of(NudgeProgram)
      Individual.new().program.should be_a_kind_of(NudgeProgram)
      Individual.new().program.raw_code.should == "block {}"
      
      probe = NudgeProgram.new("do it_now")
      Individual.new(probe).program.listing.should == "do it_now"
    end
    
    it "should respond to #genome by returning self.program.listing" do
      @i1.genome.should be_a_kind_of(String)
      @i1.program.should_receive(:listing)
      @i1.genome
    end
    
    it "should have a scores hash, which is empty" do
      @i1.scores.should == {}
    end
    
    it "should have a timestamp, which is when (wall clock time) it was made" do
      Time.should_receive(:now).and_return(Time.at(0))
      timex = Individual.new("block {}")
      timex.timestamp.should be_a_kind_of(Time)
      timex.timestamp.should == Time.at(0)
    end
    
    it "should have a progress attribute, defaulting to zero" do
      @i1.progress.should == 0
    end
    
    it "should have a station_name attribute, defaulting to an empty string" do
      @i1.station_name.should == ""
    end
    
    it "should have a list of ancestors, defaulting to none" do
      @i1.ancestors.should == []
    end
  end
  
  
  describe "parses?" do
    it "should respond to #parses? with an answer from its NudgeProgram" do
      Individual.new("block {}").parses?.should == true
      Individual.new("I do nothing at all").parses?.should == false
      Individual.new(NudgeProgram.new("neither do I")).parses?.should == false
    end
  end
  
  
  describe "#known_scores and #score_vector" do
    before(:each) do
      @oneGuy = Individual.new()
      @oneGuy.scores = {"beta" => -100, "alpha" => 100, "zeta" => 22}
    end
    
    it "known_scores should return a sorted list of the keys of the scores hash" do
      @oneGuy.known_scores.should == ["alpha", "beta", "zeta"]
    end
    
    it "should return an Array of his #scores, in order based on a template w/default known_scores" do
      @oneGuy.score_vector.should == [100,-100,22]
      @oneGuy.score_vector(["alpha"]).should == [100]
    end
  end
  
  
  
  describe "#dominated_by?" do
    before(:each) do
      @oneGuy = Individual.new
      @betterGuy = Individual.new
      @mixedGuy = Individual.new
      @extraGuy = Individual.new
      
      @oneGuy.scores =    {"beta" => -100, "alpha" => 100, "gamma" => 22 }
      @betterGuy.scores = {"beta" => -120, "alpha" => 20,  "gamma" => 0  }
      @mixedGuy.scores =  {"beta" => -10,  "alpha" => 20,  "gamma" => 100}
      @extraGuy.scores =  {"beta" => -120, "alpha" => 20,  "gamma" => 21, "delta" => 10 }
    end
    
    it "should test whether self dominates the other individual"  do
      @oneGuy.dominated_by?(@betterGuy).should == true
      @betterGuy.dominated_by?(@oneGuy).should == false
      @oneGuy.dominated_by?(@mixedGuy).should == false
      @mixedGuy.dominated_by?(@oneGuy).should == false
    end
    
    it "should use a template of score keys to establish criteria for comparison, defaulting to self's" do
      @oneGuy.dominated_by?(@mixedGuy).should == false
      @oneGuy.dominated_by?(@mixedGuy, ["alpha"]).should == true
      @mixedGuy.dominated_by?(@oneGuy, ["beta", "gamma"]).should == true
    end
    
    it "should give the benefit of the doubt when comparing against a missing score" do
      @oneGuy.dominated_by?(@extraGuy).should == true # because @extraGuy has all the same scores as self
      @oneGuy.dominated_by?(@extraGuy,["delta"]).should == false # because self has no "delta" score
      @extraGuy.dominated_by?(@oneGuy).should == false # because they're incomparible on "delta"
    end
  end
  
  
  describe "replace_point_or_clone" do
    before(:each) do
      @wildtype = Individual.new("block {value «foo»\n do some2\n block {\n value «code»}}\n«code» value «int»\n«int» 777\n«foo» bar")
      @mutant_code = "do nothing"
    end
    
    it "should return a NudgeProgram" do
      @wildtype.replace_point_or_clone(2,@mutant_code).should be_a_kind_of(NudgeProgram)
      @wildtype.replace_point_or_clone(2,InstructionPoint.new("jump_up")).should be_a_kind_of(NudgeProgram)
    end
    
    it "should return a clone of the original NudgeProgram if the position param is out of bounds" do
      @wildtype.replace_point_or_clone(-1,@mutant_code).listing.should == @wildtype.program.listing
      @wildtype.replace_point_or_clone(132,@mutant_code).listing.should == @wildtype.program.listing
      @wildtype.replace_point_or_clone(2,@mutant_code).listing.should_not == @wildtype.program.listing
    end
    
    it "should raise an ArgumentError if passed an unparseable replacement" do
      lambda{@wildtype.replace_point_or_clone(1,"")}.should raise_error(ArgumentError)
      lambda{@wildtype.replace_point_or_clone(1,"i cannot exist")}.should raise_error(ArgumentError)
      lambda{@wildtype.replace_point_or_clone(1,"do something_real")}.should_not raise_error
    end
    
    it "should produce a new parsable NudgeProgram with a new listing (as expected)" do
      @wildtype.replace_point_or_clone(1,@mutant_code).listing.should_not == @wildtype.program.listing
      @wildtype.replace_point_or_clone(1,@mutant_code).listing.should == "do nothing"
    end
    
    it "should replace the expected specific point (and any subpoints and footnotes it has)" do
      @wildtype.replace_point_or_clone(1,@mutant_code).listing.should_not include("block")
      @wildtype.replace_point_or_clone(1,@mutant_code).listing.should include("do nothing")
      
      @wildtype.replace_point_or_clone(2,@mutant_code).listing.should_not include("value «foo»")
      @wildtype.replace_point_or_clone(2,@mutant_code).listing.should_not include("bar")
      @wildtype.replace_point_or_clone(2,@mutant_code).listing.should include("do some2")
      
      @wildtype.replace_point_or_clone(3,@mutant_code).listing.should_not include("do some2")
      @wildtype.replace_point_or_clone(3,@mutant_code).listing.should include("value «code»")
      
      @wildtype.replace_point_or_clone(4,@mutant_code).listing.should_not include("value «code»")
      @wildtype.replace_point_or_clone(4,@mutant_code).listing.should_not include("777")
      @wildtype.replace_point_or_clone(4,@mutant_code).listing.should include("do some2")
      
      @wildtype.replace_point_or_clone(5,@mutant_code).listing.should_not include("value «code»")
      @wildtype.replace_point_or_clone(5,@mutant_code).listing.should include("block {\n    do nothing}")
    end
        
    it "should insert the new footnotes it needs in the right place in the footnote_section" do
      @wildtype.replace_point_or_clone(4,"value «up»\n«up» down").listing.should_not include("value «code»")
      @wildtype.replace_point_or_clone(4,"value «up»\n«up» down").listing.should include("«up» down")
    end
    
    it "should not affect extra (unused) footnotes"
    
  end
  
  
  
  
  describe "delete_point_or_clone" do
    before(:each) do
      @clipper = Individual.new("block {do some1 \n do some2 \n block {\n do some3}}")
    end
    
    it "should return a NudgeProgram"
    
    it "should return a clone of the calling Individual's program if the point is out of bounds"
    
    
    it "should return a NudgeProgram with at least one fewer program points (if the range is OK)"
    
    it "should delete the expected specific point (and any subpoints it has)"
    
    it "should return NudgeProgram.new('block {}') when the entire program is deleted"
    
    it "should delete the footnotes associated with a point it deletes"
    
    it "should not delete extra footnotes"
  end
  
  
  
  describe "Station knowledge" do
    before(:each) do
      @dude = Individual.new("block {}")
      Station.cleanup
      @where = Station.new("here")
    end
    
    it "should know its Station" do
      @where.add_individual @dude
      @dude.station_name == @where
    end
  end
  
  describe "#write behavior" do
    before(:each) do
      Station.cleanup
      @dude = Individual.new("block {}")
      @dude.scores["error"] = 1
      @dude.timestamp = Time.utc(2000,"jan",1,20,15,1)
      @where = Station.new("here")
      @where.stub!(:database => "http://127.0.0.1:5984/here")
      @where.add_individual(@dude)
      FakeWeb.allow_net_connect = false
      
      @response_body = <<-END
      {
        "id": "12345678",
        "rev": "1-12345678"
      }
      END
    end
    
    it "should write its data to the database for its Station" do
      pending ("This doesn't seem to work in the current install of couchrest")
      FakeWeb.register_uri(:post, "http://127.0.0.1:5984/here", body:@response_body)
      @dude.write
      @dude.id.should == "12345678"
    end
    
    it "should write the genome" do
      pending ("This doesn't seem to work in the current install of couchrest")
      mockDatabase = mock("fakeDB")
      CouchRest.should_receive(:database!).and_return(mockDatabase)
      mockDatabase.should_receive(:save_doc).
        with(hash_including({"genome" => "block {}"})).and_return(@response_body)
      @dude.write
    end
    
    it "should write the scores hash" do
      pending ("This doesn't seem to work in the current install of couchrest")
      
      mockDatabase = mock("fakeDB")
      CouchRest.should_receive(:database!).and_return(mockDatabase)
      mockDatabase.should_receive(:save_doc).
        with(hash_including({"scores" => {"error" => 1}})).and_return(@response_body)
      @dude.write
    end
    
    it "should write the Time.now" do
      pending ("This doesn't seem to work in the current install of couchrest")
      
      mockDatabase = mock("fakeDB")
      CouchRest.should_receive(:database!).and_return(mockDatabase)
      mockDatabase.should_receive(:save_doc).
        with(hash_including({"creation_time" => Time.utc(2000,"jan",1,20,15,1)})).and_return(@response_body)
      @dude.write
    end
  end 

  
  describe "#get" do
    before(:each) do
      @url = "http://localhost:5984/here"
      @individual_id = "88888"
      @genome = "do int_add"
      
      @response_body = <<-END
      {
        "_id": "88888",
        "_rev": "1-12345678",
        "genome": "#{@genome}"
      }
      END
      
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(:get, "#{@url}/#{@individual_id}", body:@response_body)
    end
    
    it "retrive an individual from the data store by id" do
      @dude = Individual.get(@url, @individual_id)
      @dude.id.should == @individual_id
      @dude.genome.should == @genome
    end
    
    it "should handle connection errors"
  end
  
end
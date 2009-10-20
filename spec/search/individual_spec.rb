require File.join(File.dirname(__FILE__), "./../spec_helper")
include Nudge

describe "Individual" do
  describe "initialization" do
    before(:each) do
      @i1 = Individual.new("literal bool (false)")
    end
    
    it "should have a unique [serial] identifier after saving" 
    
    it "should have a genome string, with no default value" do
      @i1.genome.should be_a_kind_of(String)
      lambda{Individual.new()}.should raise_error
    end
    
    it "should have a program attribute, which is the parsed genome" do
      @par = NudgeLanguageParser.new
      expected = @par.parse(@i1.genome).to_points
      @i1.program.tidy.should == expected.tidy
    end
    
    it "should have a scores hash, which is empty" do
      @i1.scores.should == {}
    end
    it "should have a timestamp, which is when (wall clock time) it was made" do
      @i1.timestamp.should be_a_kind_of(Time)
    end
    it "should have an age, defaulting to zero" do
      @i1.age.should == 0
    end
    it "should have a locationID, defaulting to an empty string" do
      @i1.location.should == ""
    end
    it "should have a list of ancestors, defaulting to none" do
      @i1.ancestors.should == []
    end
  end
  
  describe "runnable?" do
    it "should have a genome that an interpreter can understand" do
      @i1 = Individual.new(fixture(:long_arithmetic))
      @interp = Interpreter.new()
      @interp.reset(@i1.genome)
      @interp.run
      Stack.stacks[:int].peek.value.should == -36
    end
  end
  
  describe "#known_scores and #score_vector" do
    before(:each) do
      @oneGuy = Individual.new("block {}")
      @oneGuy.scores = {"beta" => -100, "alpha" => 100, "zeta" => 22}
    end
    
    it "known_scores should return a sorted list of the keys of the scores hash" do
      @oneGuy.known_scores.should == ["alpha", "beta", "zeta"]
    end
    
    it "should return an Array of the values of his #scores, in order based on a template w/default known_scores" do
      @oneGuy.score_vector.should == [100,-100,22]
      @oneGuy.score_vector(["alpha"]).should == [100]
    end
  end
  
  describe "#dominated_by?" do
    before(:each) do
      @oneGuy = Individual.new("block {}")
      @betterGuy = Individual.new("block {}")
      @mixedGuy = Individual.new("block {}")
      @extraGuy = Individual.new("block {}")
      
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
  
end
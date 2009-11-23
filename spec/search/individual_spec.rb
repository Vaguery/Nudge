require File.join(File.dirname(__FILE__), "./../spec_helper")
include Nudge

describe "Individual" do
  describe "class methods" do
    it "should have a class attribute Parser for validating code" do
      Individual.helperParser.should be_a_kind_of(NudgeLanguageParser)
    end
  end
  
  describe "initialization" do
    before(:each) do
      @i1 = Individual.new("literal bool (false)")
    end
    
    it "should have a genome string, with no default value" do
      @i1.genome.should be_a_kind_of(String)
      lambda{Individual.new()}.should raise_error
    end
    
    it "should have a program attribute, which is the parsed genome" do
      @par = NudgeLanguageParser.new
      expected = @par.parse(@i1.genome).to_points
      @i1.program.tidy.should == expected.tidy
    end
    
    it "should raise an ArgumentError if the genome doesn't parse" do
      lambda{Individual.new("bad stuff happens")}.should raise_error(ArgumentError)
      lambda{Individual.new("block {")}.should raise_error(ArgumentError)
      lambda{Individual.new("}")}.should raise_error(ArgumentError)
      
      lambda{Individual.new("")}.should raise_error(ArgumentError)
      lambda{Individual.new("block {}")}.should_not raise_error(ArgumentError)
    end
    
    it "should have a scores hash, which is empty" do
      @i1.scores.should == {}
    end
    it "should have a timestamp, which is when (wall clock time) it was made" do
      @i1.timestamp.should be_a_kind_of(Time)
    end
    it "should have an age, defaulting to zero" do
      @i1.progress.should == 0
    end
    it "should have a locationID, defaulting to an empty string" do
      @i1.station.should == ""
    end
    it "should have a list of ancestors, defaulting to none" do
      @i1.ancestors.should == []
    end
  end
  
  
  
  describe "runnable?" do
    it "should have a genome that an interpreter can understand" do
      @i1 = Individual.new(fixture(:long_arithmetic))
      @interp = Interpreter.new
      @interp.reset(@i1.genome)
      @interp.enable_all_instructions
      @interp.run
      @interp.stacks[:int].peek.value.should == -36
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
    
    it "should return an Array of his #scores, in order based on a template w/default known_scores" do
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
  
  
  
  describe "isolate_point" do
    before(:each) do
      @snipper = Individual.new("block {do some1 \n do some2 \n block {\n do some3}}")
    end
    
    it "should raise an ArgumentError if the integer param referring to a particular point is OOB" do
      lambda{@snipper.isolate_point()}.should raise_error(ArgumentError)
      lambda{@snipper.isolate_point(-12)}.should raise_error(ArgumentError)
      lambda{@snipper.isolate_point(912)}.should raise_error(ArgumentError)
      
      lambda{@snipper.isolate_point(2)}.should_not raise_error(ArgumentError)
    end
    
    it "should return a Hash containing up to three items" do
      works = @snipper.isolate_point(2)
      works.should be_a_kind_of(Hash)
      works.length.should == 3
      works.each_value {|chunk| chunk.should be_a_kind_of(String)}
      
      @snipper.isolate_point(1).length.should == 1
      @snipper.isolate_point(5).length.should == 3
    end
    
    it "should include the material in the genome before the point in the first string" do
      works = @snipper.isolate_point(2)
      works[:left].should include("block {")
      works[:left].should_not include("}")
      
      whole = @snipper.isolate_point(1)
      whole[:left].should == nil
    end
    
    it "should include the material in the genome after the point in the third string" do
      works = @snipper.isolate_point(2)
      works[:right].should include("do some2")
      works[:right].should_not include("do some1")
      
      whole = @snipper.isolate_point(1)
      whole[:right].should == nil
      
      bracesLeft = @snipper.isolate_point(5)
      bracesLeft[:right].should == "}}"
    end
    
    it "should include the isolated point in the middle string" do
      works = @snipper.isolate_point(2)
      works[:middle].strip.should == "do some1"
      
      @snipper.isolate_point(3)[:middle].strip.should == "do some2"
      @snipper.isolate_point(4)[:middle].gsub(/([\s]+)/," ").should == "block { do some3}"
      @snipper.isolate_point(5)[:middle].strip.should == "do some3"
    end
  end
  
  
  
  describe "delete_point" do
    before(:each) do
      @clipper = Individual.new("block {do some1 \n do some2 \n block {\n do some3}}")
      @parser = NudgeLanguageParser.new()
    end
    
    it "should return Individual#genome if[f] the position param is out of bounds" do
      @clipper.delete_point(-12).should == @clipper.program.listing
      @clipper.delete_point(933).should == @clipper.program.listing
      @clipper.delete_point(2).should_not == @clipper.program.listing
    end
    
    it "should call self#isolate_point to slice the wildtype genome" do
      @clipper.should_receive(:isolate_point).with(2).and_return(
        {:left => "so",:middle=>"it",:right=>"works"})
      @clipper.delete_point(2)
    end
    
    it "should produce a parsable genome" do
      (0..5).each do |where|
        @parser.parse(@clipper.delete_point(2)).should_not == nil
      end
    end
    
    it "should return a genome with at least one fewer program points" do
      startPoints = @clipper.points
      (0..5).each do |where|
        @parser.parse(@clipper.delete_point(2)).to_points.points.should < startPoints
      end
    end
        
    it "should delete the expected specific point (and any subpoints it has)" do
      @parser.parse(@clipper.delete_point(2)).to_points.points.should == 4
      @parser.parse(@clipper.delete_point(3)).to_points.points.should == 4
      @parser.parse(@clipper.delete_point(4)).to_points.points.should == 3
      @parser.parse(@clipper.delete_point(5)).to_points.points.should == 4
    end
    
    it "should return 'block {}' when the entire program is deleted" do
      @clipper.delete_point(1).should == "block {}"
    end
  end
  
  
  describe "replace_point" do
    before(:each) do
      @receiver = Individual.new("block {do some1 \n do some2 \n block {\n do some3}}")
      @parser = NudgeLanguageParser.new()
      @mutant = "do NOTHING"
    end
    
    it "should return Individual#genome if[f] the position param is out of bounds" do
      @receiver.replace_point(-1,@mutant).should == @receiver.program.listing
      @receiver.replace_point(132,@mutant).should == @receiver.program.listing
      @receiver.replace_point(2,@mutant).should_not == @receiver.program.listing
    end
    
    it "should raise an ArgumentError if passed an empty replacement" do
      lambda{@receiver.replace_point(1,"")}.should raise_error(ArgumentError)
    end
    
    
    it "should call self#isolate_point to slice the wildtype genome" do
      @receiver.should_receive(:isolate_point).with(2).and_return(
        {:left => "so ",:middle=>"it",:right=>" works"})
      @receiver.replace_point(2,"this")
    end
    
    it "should produce a parsable genome" do
      @parser.parse(@receiver.replace_point(2,@mutant)).should_not == nil
      @parser.parse(@receiver.replace_point(1,@mutant)).should_not == nil
    end
    
    it "should replace the expected specific point (and any subpoints it has)" do
      @receiver.replace_point(2,@mutant).should_not include("some1")
      @receiver.replace_point(3,@mutant).should_not include("some2")
      @receiver.replace_point(4,@mutant).should_not include("some3")
      @receiver.replace_point(5,@mutant).should_not include("some3")
      @receiver.replace_point(1,@mutant).should_not include("block")
    end

    it "should replace the entire program if it replaces point 0" do
      @receiver.replace_point(1,@mutant).should == " do NOTHING "
    end
    
  end
  
  
  
end
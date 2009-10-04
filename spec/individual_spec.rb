require File.join(File.dirname(__FILE__), "./spec_helper")
include Nudge

describe "Individual" do
  describe "initialization" do
    before(:each) do
      @i1 = Individual.new("literal bool (false)")
    end
    
    it "should have a unique [serial] identifier" do
      @i1 = Individual.new("literal bool(false)")
      @i2 = Individual.new("literal bool(false)")
      @i2 = Individual.new("literal bool(false)")
      @i2.uniqueID.should == (@i1.uniqueID + 2)
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
    
    it "should have a scores hash, which is empty" do
      @i1.scores.should == {}
    end
    it "should have a timestamp, which is when (wall clock time) it was made" do
      @i1.timestamp.should be_a_kind_of(Time)
    end
    it "should have an age, defaulting to zero" do
      @i1.age.should == 0
    end
    it "should have a locationID, defaulting to 0" do
      @i1.location.should == 0
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
  
end
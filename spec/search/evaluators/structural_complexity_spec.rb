require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe "ProgramPointsEvaluator" do
  describe "evaluate method" do
    before(:all) do
      @myCounter = ProgramPointsEvaluator.new
      @shorty = Individual.new("block {}")
      @longy = Individual.new("block { block { block {} block { block { block {}}}}}")
    end
    
    it "should have a name attribute that is a Symbol, which it'll use to record scores" do
      @myCounter.name.should == :program_points
    end
    
    it "should complain if you try to set the #name to anything but a Symbol" do
      lambda{@myCounter.name = "hi there"}.should raise_error(ArgumentError)
      lambda{@myCounter.name = :othello}.should_not raise_error
    end
    
    it "should take an Individual as a parameter" do
      lambda{@myCounter.evaluate()}.should raise_error(ArgumentError)
      lambda{@myCounter.evaluate(91)}.should raise_error(ArgumentError)
      lambda{@myCounter.evaluate([])}.should raise_error(ArgumentError)
      lambda{@myCounter.evaluate(@shorty)}.should_not raise_error(ArgumentError)
    end
    
    it "should measure the number of program points in the dude" do
      @shorty.should_receive(:points)
      @myCounter.evaluate(@shorty)
    end
    
    it "should return the number of program points" do
      @myCounter.evaluate(@longy).should == 6
    end
    
    it "should by default write the result into the Individual's #scores hash" do
      @myCounter.evaluate(@shorty)
      @shorty.scores.should include(:program_points)
      @shorty.scores[:program_points].should == 1
    end
    
    it "should take an optional Boolean parameter that tells not to bother writing the score" do
      @shorty.scores = {}
      @myCounter.evaluate(@shorty, true).should == 1
      @shorty.scores.should_not include(:program_points)
      @shorty.scores[:program_points].should_not == 1
      @myCounter.evaluate(@shorty)
      @shorty.scores[:program_points].should == 1
    end
  end
end
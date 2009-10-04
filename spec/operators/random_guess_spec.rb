require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "random_guess operator" do
  before(:each) do
    CodeType.deactivate #FIXME I should be unnecessary once CODE literals work
  end
  
  it "should be a kind of SearchOperator" do
    myGuesser = RandomGuess.new
    myGuesser.should be_a_kind_of(SearchOperator)
  end
  
  it "should produce an Individual when it receives #generate" do
    myGuesser = RandomGuess.new
    newDude = myGuesser.generate
    newDude.should be_a_kind_of(Individual)
    newDude.genome.should_not == nil
    newDude.program.should_not == nil
  end
  
  it "should have a parsed genome as its #program attribute" do
    myGuesser = RandomGuess.new
    newDude = myGuesser.generate
    newDude.program.should be_a_kind_of(CodeBlock)
  end
  
  it "should accept params to pass into CodeType.random_value" do
    myGuesser = RandomGuess.new
    lambda{
      myGuesser.generate(:points => 7, :instructions => [IntAddInstruction, IntSubtractInstruction], :references => ["x1", "x2", "x3"])}.should_not raise_error
      myGuesser.generate(:points => 7).program.points.should == 7
  end
end
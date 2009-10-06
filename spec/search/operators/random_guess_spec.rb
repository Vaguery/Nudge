require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "random_guess operator" do
  before(:each) do
    CodeType.deactivate #FIXME I should be unnecessary once CODE literals work
    @myGuesser = RandomGuess.new
  end
  
  it "should be a kind of SearchOperator" do
    @myGuesser.should be_a_kind_of(SearchOperator)
  end
  
  it "should produce a set of Individuals when it receives #generate" do
    newDudes = @myGuesser.generate
    newDudes.should be_a_kind_of(Array)
    newDudes[0].should be_a_kind_of(Individual)
    newDudes[0].genome.should_not == nil
    newDudes[0].program.should_not == nil
  end
  
  it "should produce one as a default, more if a higher number is passed in as a second parameter" do
    @myGuesser.generate({}).length.should == 1
    @myGuesser.generate({},4).length.should == 4
  end
  
  it "should have a parsed genome as its #program attribute" do
    newDudes = @myGuesser.generate
    newDudes[0].program.should be_a_kind_of(CodeBlock)
  end
  
  it "should accept params to pass into CodeType.random_value" do
    lambda{
      @myGuesser.generate(:points => 7, :instructions => [IntAddInstruction, IntSubtractInstruction], :references => ["x1", "x2", "x3"])}.should_not raise_error
      @myGuesser.generate(:points => 7)[0].program.points.should == 7
  end
end
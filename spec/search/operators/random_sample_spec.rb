require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "random_sample operator" do
  it "should be a kind of SearchOperator" do
    mySampler = RandomSample.new
    mySampler.should be_a_kind_of(SearchOperator)
  end

  it "should produce an Individual when it receives #generate" do
    myGuesser = RandomGuess.new
    pop = []
    3.times {pop << myGuesser.generate(:types => [IntType])}
    mySampler = RandomSample.new
    newDude = mySampler.generate(pop)
    newDude.should be_a_kind_of(Individual)
    newDude.genome.should_not == nil
    newDude.program.should_not == nil
  end
  
  it "should produce an Individual with a genome identical to one of the passed in crowd's" do
    myGuesser = RandomGuess.new
    pop = [myGuesser.generate(:types => [IntType])]
    mySampler = RandomSample.new
    newDude = mySampler.generate(pop)
    newDude.genome.should == pop[0].genome
  end
  
  it "should have a parsed genome as its #program attribute" do
    myGuesser = RandomGuess.new
    pop = []
    3.times {pop << myGuesser.generate(:types => [IntType])}
    
    mySampler = RandomSample.new
    newDude = mySampler.generate(pop)
    newDude.program.should be_a_kind_of(CodeBlock)
  end
end
require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "random_resample operator" do
  before(:each) do
    @myGuesser = RandomGuessOperator.new(:types => [IntType], :instructions => [IntAddInstruction])
    @mySampler = PopulationResampleOperator.new
  end
  
  it "should be a kind of SearchOperator" do
    @mySampler.should be_a_kind_of(SearchOperator)
  end

  it "should produce a list of Individuals when it receives #generate" do
    newDudes = @mySampler.generate(@myGuesser.generate(3))
    newDudes.should be_a_kind_of(Array)
    newDudes[0].should be_a_kind_of(Individual)
    newDudes[0].genome.should_not == nil
    newDudes[0].program.should_not == nil
  end
  
  it "should produce one Individual with a genome identical to one of the passed in crowd's" do
    pop = @myGuesser.generate(1)
    newDudes = @mySampler.generate(pop)
    newDudes[0].genome.should == pop[0].genome
  end
  
  it "should return more than one individual when asked to, resampling as needed" do
    newDudes = @mySampler.generate(@myGuesser.generate(10))
    newDudes.length.should == 1
    newDudes = @mySampler.generate(@myGuesser.generate(3),2)
    newDudes.length.should == 2
    newDudes = @mySampler.generate(@myGuesser.generate(1),2)
    newDudes.length.should == 2
    newDudes[0].genome.should == newDudes[1].genome
  end
  
  it "should have a parsed genome as its #program attribute" do
    pop = @myGuesser.generate(3)
    newDudes = @mySampler.generate(pop)
    newDudes[0].program.should be_a_kind_of(CodeBlock)
  end
  
  it "should increment the #progress of each clone" do
    pop = @myGuesser.generate(3)
    pop.each {|donor| donor.progress = 12}
    newDudes = @mySampler.generate(pop)
    newDudes.each {|kid| kid.progress.should == 13}
  end
end
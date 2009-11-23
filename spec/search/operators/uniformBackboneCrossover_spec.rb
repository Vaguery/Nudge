require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "UniformBackboneCrossoverOperator" do
  before(:each) do
    @newDudes = []
    @params = {:points => 3, :instructions => [IntAddInstruction], :types => [IntType]}
    @myXover = UniformBackboneCrossoverOperator.new
    @myGuesser = RandomGuessOperator.new(@params)
  end
  
  it "should be a kind of SearchOperator" do
    @myXover.should be_a_kind_of(SearchOperator)
  end
  
  it "should produce a Batch of Individuals when it receives #generate" do
    @newDudes = @myXover.generate(@myGuesser.generate(2))
    @newDudes.should be_a_kind_of(Batch)
    @newDudes.each {|dude| dude.should be_a_kind_of(Individual)}
  end
  
  it "should produce the same number of Individuals it gets as a default" do
    @newDudes = @myXover.generate(@myGuesser.generate(6))
    @newDudes.length.should == 6
  end
  
  it "should have an optional parameter that specifies the number of offspring to produce" do
    @newDudes = @myXover.generate(@myGuesser.generate(2),5)
    @newDudes.length.should == 5
  end
  
  it "should only include backbone points from one of the parents in the offsprings' genomes" do
    rents = @myGuesser.generate(2)
    @newDudes = @myXover.generate(rents,1)
    @newDudes.length.should == 1
    allParentalPoints = rents[0].program.contents + rents[1].program.contents
    allTidied = allParentalPoints.collect {|pt| pt.tidy}
    @newDudes[0].program.contents.each {|pt| allTidied.should include(pt.tidy)}
  end
  
  it "should return an identical individual if given only one parent" do
    rent = @myGuesser.generate(1)
    @newDudes = @myXover.generate(rent,3)
    @newDudes.each {|kid| kid.program.tidy.should == rent[0].program.tidy}
  end
  
  
  it "should not affect the original parents set in any way" do
    rents = @myGuesser.generate(2)
    originalMom = rents[0].object_id
    @newDudes = @myXover.generate(rents,1)
    rents[0].object_id.should == originalMom
  end
  
  it "should return offspring with #progress values incremented from the largest parent value" do
    rents = @myGuesser.generate(2)
    rents[0].progress = 12
    rents[1].progress = 33
    @newDudes = @myXover.generate(rents,20)
    @newDudes.each {|baby| [13, 34].should include(baby.progress)}
  end
  
end
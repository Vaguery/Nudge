require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "sizePreservingMutation operator" do
  before(:each) do
    @newDudes = []
    @params = {:points => 10, :blocks => 0, :instructions => [IntAddInstruction, IntSubtractInstruction], :types => [IntType]}
    @myMutie = SizePreservingMutation.new
    @myGuesser = RandomGuess.new
  end
  
  it "should be a kind of SearchOperator" do
    @myMutie.should be_a_kind_of(SearchOperator)
  end
  
  it "should be possible to initialize it with a params hash" do
    lambda{SizePreservingMutation.new(@params)}.should_not raise_error
  end
  
  it "should produce a set of Individuals when it receives #generate"
  
  it "should produce the same number of Individuals it gets as a default"
  
  it "should have an optional parameter that specifies the number of offspring to produce"
  
  it "should use its own params to set constraints on mutant code generated"
  
  it "should use the params even for single-line code"
  # 
  # it "should only include backbone points from one of the parents in the offsprings' genomes" do
  #   rents = @myGuesser.generate(@params,2)
  #   @newDudes = @myXover.generate(rents,1)
  #   @newDudes.length.should == 1
  #   allParentalPoints = rents[0].program.contents + rents[1].program.contents
  #   allTidied = allParentalPoints.collect {|pt| pt.tidy}
  #   @newDudes[0].program.contents.each {|pt| allTidied.should include(pt.tidy)}
  # end
  # 
  # it "should return an identical individual if given only one parent" do
  #   rent = @myGuesser.generate(@params,1)
  #   @newDudes = @myXover.generate(rent,3)
  #   @newDudes.each {|kid| kid.program.tidy.should == rent[0].program.tidy}
  # end
  # 
  # 
  # it "should not affect the original parents set in any way" do
  #   rent = @myGuesser.generate(@params,2)
  #   originalMom = rent[0].object_id
  #   @newDudes = @myXover.generate(rent,1)
  #   rent[0].object_id.should == originalMom
  # end
  # 
end
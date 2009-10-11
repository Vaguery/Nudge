require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "sizePreservingMutation operator" do
  before(:each) do
    @newDudes = []
    @originalParams = {:points => 10, :blocks => 0, :instructions => [IntAddInstruction, IntSubtractInstruction], :types => [IntType]}
    @replacementParams = {:points => 1, :instructions => [FloatSubtractInstruction], :types => FloatType}
    @myMutie = SizePreservingMutation.new
    @myGuesser = RandomGuess.new(@originalParams)
    CodeType.deactivate #FIXME I should be unnecessary once CODE literals work
  end
  
  it "should be a kind of SearchOperator" do
    @myMutie.should be_a_kind_of(SearchOperator)
  end
  
  it "should be possible to initialize it with a params hash" do
    lambda{SizePreservingMutation.new(@originalParams)}.should_not raise_error
  end
  
  it "should produce a set of Individuals when it receives #generate" do
    littleCrowd = @myGuesser.generate(1)
    mutant = @myMutie.generate(littleCrowd)
    mutant.should be_a_kind_of(Array)
    mutant[0].should be_a_kind_of(Individual)
  end
  
  it "should produce the same number of Individuals it gets as a default" do
    littleCrowd = @myGuesser.generate(4)
    mutants = @myMutie.generate(littleCrowd)
    mutants.length.should == 4
  end
  
  it "should have an optional parameter that specifies the number of offspring to produce" do
    littleCrowd = @myGuesser.generate(4)
    mutants = @myMutie.generate(littleCrowd,11)
    mutants.length.should == 11
  end
  
  describe "should work (produce mutants with the same point length with different code)" do
    it "when there are no blocks at all in original code" do
      littleCrowd = @myGuesser.generate(1,:points => 1, :blocks => 0, :references => ["x1"],:types => [IntType])
      mutants = @myMutie.generate(littleCrowd)
      mutants[0].points.should == littleCrowd[0].points
      mutants[0].program.tidy.should_not == littleCrowd[0].program.tidy
    end
    
    it "when there is only one block in original code" do
      littleCrowd = [Individual.new("block {}")]
      mutants = @myMutie.generate(littleCrowd)
      mutants[0].object_id.should_not == littleCrowd[0].object_id
    end
    
    
    it "when there are only blocks in original code" do
      littleCrowd = [Individual.new("block { block{ block {}} block {}}")]
      lambda{@myMutie.generate(littleCrowd)}.should_not raise_error
      mutants = @myMutie.generate(littleCrowd)
      mutants[0].points.should == littleCrowd[0].points
      
    end
    
  end
  
  it "should use its own params to set constraints on mutant code generated"
  it "should use the params even for single-line code"
  it "should not affect the original parents set in any way"
end
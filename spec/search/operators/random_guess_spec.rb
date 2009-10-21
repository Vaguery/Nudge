require File.join(File.dirname(__FILE__), "./../../spec_helper")
include Nudge

describe "random_guess operator" do
  before(:each) do
    @myGuesser = RandomGuess.new
    BoolType.activate
  end
  
  it "should be a kind of SearchOperator" do
    @myGuesser.should be_a_kind_of(SearchOperator)
  end
  
  it "should have a params attribute when created that sets basic values for code generation" do
    RandomGuess.new.params.should == {}
    thisGuesser = RandomGuess.new(:points => 3, :blocks => 1)
    thisGuesser.params.should_not == {}
    thisGuesser.params[:points].should == 3
  end
  
  it "should produce a set of Individuals when it receives #generate" do
    newDudes = @myGuesser.generate
    newDudes.should be_a_kind_of(Array)
    newDudes[0].should be_a_kind_of(Individual)
    newDudes[0].genome.should_not == nil
    newDudes[0].program.should_not == nil
  end
  
  it "should produce one as a default, more if a higher number is passed in" do
    @myGuesser.generate.length.should == 1
    @myGuesser.generate(4).length.should == 4
  end
  
  it "should have a parsed genome as its #program attribute" do
    newDudes = @myGuesser.generate
    newDudes[0].program.should be_a_kind_of(CodeBlock)
  end
  
  it "should accept temporarily overriding params to pass into CodeType.random_value" do
    @myNewGuesser = RandomGuess.new(
      :points => 7, :instructions => [IntAddInstruction, IntSubtractInstruction],
      :references => ["x1", "x2", "x3"])
    lambda{@myNewGuesser.generate(3,:points => 12, :references => ["y1"])}.should_not raise_error
    @myNewGuesser.generate(3,:points => 12)[0].program.points.should_not == 7
    @myNewGuesser.generate(3,:points => 12)[0].program.points.should == 12
    @myNewGuesser.generate(1,:points => 6, :blocks => 0, :types => [], :instructions => [], :references => ["y1"])[0].genome.should include("y1")
  end
end
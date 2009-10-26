require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe "Expectations" do
  it "should have a #setup Hash" do
    Expectation.new.setup.should be_a_kind_of(Hash)
  end
  it "should have an #expected Hash" do
    Expectation.new.expected.should be_a_kind_of(Hash)
  end
  it "should have a #observers Hash" do
    Expectation.new.observers.should be_a_kind_of(Hash)
  end
  
  describe "create_bindings" do
    it "should iterate through #setup and bind all variables in the #setup Hash"
    # so if setup = {"x1" => "literal int(0)", "x2" => "literal bool(false)"}
    # the create_bindings method will make two variables, pointing to those specified literals
  end
  
  describe "match_outcomes" do
    it "should look at each key in #expected for the name of a variable"
    it "should look up the correct Proc (with the same variable name key) in #observers"
    it "should apply each Proc to the current state after the run"
    ## the Procs should use #peek to examine the state of the stacks
    it "should return a hash {'expected' => X, 'observed' => x}"
    # for each output variable of interest
  end
  
end



describe "SummedAbsoluteError" do
  describe "evaluate method" do
    before(:all) do
      @accuracy = SummedAbsoluteError.new
      @dude1 = Individual.new("block { sample int(7) ref x1 do int_add}")
    end
    
    it "should have a #name attribute that is a Symbol, which it'll use to record scores" do
      @accuracy.name.should == :summed_absolute_error
    end
    
    describe "expectations" do
      it "should have a set of #expectations, established during initialization" 

      it "should be an Array"
      
      it "should default to an Array containing zero or more Expectations"
    end
    
    
    it "should take an Individual as a parameter" do
      lambda{@accuracy.evaluate()}.should raise_error(ArgumentError)
      lambda{@accuracy.evaluate(22)}.should raise_error(ArgumentError)
      lambda{@accuracy.evaluate([])}.should raise_error(ArgumentError)
      
      lambda{@accuracy.evaluate(@dude1)}.should_not raise_error(ArgumentError)
    end
    
    it "should run the Individual using each of its training cases"
    
    it "should use #observe to measure (or calculate) the salient value in one training case"
    
    it "should be able to run #observe even when no value is generated"
    
    it "should return the summed absolute error over all training cases"
    
    it "should by default write the result into the Individual's #scores hash using its #name"
    
    it "should take an optional Boolean parameter that tells not to bother writing the score"
    
    it "should be able to handle training cases in which there are unassigned bindings"
    
  end
end
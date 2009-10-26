module Nudge
  
  class Expectation
    attr_accessor :setup, :expected, :observers
    
    def initialize(setup = {}, expected = {}, observers = {})
      @setup = setup
      @expected = expected
      @observers = observers
    end
    
  end
  
  
  
  class SummedAbsoluteError < Evaluator
    attr_accessor :name, :training_cases
    
    def initialize(examples = [])
      @name = :summed_absolute_error
      @training_cases = examples
    end
    
    def evaluate(dude, silent=false)
      raise(ArgumentError, "Can only evaluate an Individual") if dude.class != Individual
      
    end
  end
  
  
end
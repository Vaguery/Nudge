module Nudge
  class Evaluator
    def initialize
      raise "Your subclass of Evaluator should set its own @name when initializing"
    end
    
    def evaluate(dude)
      raise "Your subclass of Evaluator should have a unique #evaluate method"
    end
  end
  
end
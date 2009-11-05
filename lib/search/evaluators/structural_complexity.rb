module Nudge

  class ProgramPointsEvaluator < Evaluator
    def initialize
      @name = :program_points
    end
    
    def name
      @name
    end
    
    def name=(newName)
      raise(ArgumentError, "Evaluator name must be a Symbol") if !newName.kind_of?(Symbol)
      @name = newName
    end
    
    def evaluate(dude, silent=false)
      raise(ArgumentError, "Can only evaluate an Individual") if dude.class != Individual
      result = dude.points
      dude.scores[:program_points]=result unless silent
      return result
    end
  end
  
end
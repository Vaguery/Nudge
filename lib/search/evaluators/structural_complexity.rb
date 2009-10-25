module Nudge

  class ProgramPointsEvaluator < Evaluator
    attr_accessor :name
    
    def initialize
      @name = :program_points
    end
    
    def evaluate(dude, silent=false)
      raise(ArgumentError, "Can only evaluate an Individual") if dude.class != Individual
      result = dude.points
      dude.scores[:program_points]=result unless silent
      return result
    end
  end

end
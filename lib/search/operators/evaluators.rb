module Nudge
  
  class Evaluator < SearchOperator
    attr_accessor :name
    
    def initialize(params = {})
      raise(ArgumentError, "Evaluators must be initialized with names") if params[:name] == nil
      @name = params[:name]
    end
  end
  
  
  class ProgramPointEvaluator < Evaluator
    def evaluate(batch)
      raise(ArgumentError, "Can only evaluate a Batch of Individuals") if !batch.kind_of?(Array)
      batch.each {|i| i.scores[@name] = i.points}
    end
  end
end
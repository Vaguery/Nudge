module Nudge

  class SummedAbsoluteError < Evaluator
    attr_accessor :name, :training
    
    def initialize
      @name = :summed_absolute_error
    end
    
    def evaluate(dude, silent=false)
    end
  end

end
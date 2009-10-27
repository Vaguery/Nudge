module Nudge
  class SummedSquaredError < Evaluator
    @@defaultPenalty = 1000000
    attr_accessor :name, :penalty, :probe
    
    
    def initialize(penalty = nil)
      @name = :summed_squared_error
      @penalty = (penalty || @@defaultPenalty)
      @probe = Proc.new {|interpreter| interpreter.steps}
    end
    
    
    def analyze(result, finished_interpreter)
      result.observed = @probe.call(finished_interpreter)
    end
    
    
    def aggregate(resultsList)
      raise ArgumentError if !resultsList.kind_of?(Array)
      sse = 0
      resultsList.each do |r|
        sse += (r.observed ? (r.expected - r.observed)**2 : @penalty)
      end
      return sse
    end
    
  end
end
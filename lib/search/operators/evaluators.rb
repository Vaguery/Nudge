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
      raise(ArgumentError, "Can only evaluate a Batch of Individuals") if !batch.kind_of?(Batch)
      batch.each {|i| i.scores[@name] = i.points}
    end
  end
  
  
  
  
  
  class TestCase
    attr_accessor :bindings, :expectations, :gauges
    
    def initialize(args = {})
      @bindings = args[:bindings] || Hash.new
      @expectations = args[:expectations] || Hash.new
      @gauges = args[:gauges] || Hash.new
      
      if (@expectations.keys - @gauges.keys).length > 0
        raise ArgumentError, "One or more expectations have no defined gauge"
      end
    end
  end
  
  
  
  
  
  class TestCaseEvaluator < Evaluator
    def evaluate(batch, cases = [], params = {})
      raise(ArgumentError, "Can only evaluate a Batch of Individuals") if !batch.kind_of?(Batch)
      
      batch.each do |dude|
        score = 0
        cases.each do |c|
          # make an Interpreter
          # set up the program
          # set up the bindings
          # run it
          # apply the gauge(s) for each expectation
          # collect differences
        end
        # aggregate differences
        dude.scores[@name] = 99.1
      end
    end
    
  end
end
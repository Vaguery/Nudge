module Nudge
  
  class Interpreter
    attr_accessor :parser, :stepLimit, :steps
    
    def initialize(initialProgram=nil)
      @parser = NudgeLanguageParser.new()
      if initialProgram
        self.load(initialProgram)
      end
      @stepLimit = 3000
      @steps = 0
    end
    
    def load(program)
      newCode = @parser.parse(program).to_points
      Stack.cleanup
      Stack.push!(:exec,newCode)
    end
    
    def notDone?
      Stack.stacks[:exec].depth > 0 && @steps < @stepLimit
    end
    
    def step
      if notDone?
        nextPoint = Stack.stacks[:exec].pop 
        nextPoint.go
        @steps += 1
      end
    end
    
    def run
      while notDone?
        self.step
      end
    end
    
  end
end
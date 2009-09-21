module Nudge
  
  class Interpreter
    attr_accessor :parser
    
    def initialize(initialProgram=nil)
      @parser = NudgeLanguageParser.new()
      if initialProgram
        self.load(initialProgram)
      end
    end
    
    def load(program)
      newCode = @parser.parse(program).to_points
      Stack.cleanup
      Stack.push!(:exec,newCode)
    end
    
    def step
      nextPoint = Stack.stacks[:exec].pop
      nextPoint.go
    end
    
  end
end
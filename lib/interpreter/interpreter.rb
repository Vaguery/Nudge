module Nudge
  
  class Interpreter
    attr_accessor :parser
    def initialize()
      @parser = NudgeLanguageParser.new()
    end
    
    
  end
end
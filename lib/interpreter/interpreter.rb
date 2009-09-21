module Nudge
  
  class Interpreter
    attr_accessor :parser, :stacks
    
    def initialize(listing=nil)
      @parser = NudgeLanguageParser.new()
      @stacks = {}
      if listing
        self.load(listing)
      end
    end
    
    def load(listing)
      newCode = @parser.parse(listing)
      @stacks["exec"] = Stack.new("exec")
      @stacks["exec"].push newCode.to_points
    end
    
  end
end
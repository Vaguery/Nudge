module Nudge
  class Code
    
    attr_accessor :listing
    
    def initialize(rawCode=nil)
      @listing = rawCode || "block"
    end
    
    def parsed
      parser = NudgeLanguageParser.new
      return parser.parse(@listing)
    end
    
  end
end
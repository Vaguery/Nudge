
module Nudge
  class Code
    @parser = NudgeLanguageParser.new()
 
    def self.parser
      @parser
    end
    
    attr_accessor :listing, :contents
    
    def initialize(rawCode=nil)
      @listing = rawCode || "block {}"
    end
    
    def points
      return @listing.split(/\n/).length
    end
    
  end
end
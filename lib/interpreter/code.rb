module Nudge
  class Code
    @@parser = NudgeLanguageParser.new
    
    def self.parse(someListing)
      @@parser.parse(someListing)
    end
    
    attr_accessor :listing, :parsed, :contents
    
    def initialize(rawCode=nil)
      @listing = rawCode || "block {}"
      @parsed = @@parser.parse(@listing)
    end
    
    def points
      return @listing.split(/\n/).length
    end
  end
end
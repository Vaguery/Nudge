module Nudge
  class Code
    
    attr_accessor :listing, :contents
    
    def initialize(rawCode=nil)
      @listing = rawCode || "block {}"
    end
    
    def points
      return @listing.split(/\n/).length
    end
    
  end
end
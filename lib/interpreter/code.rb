module Nudge
  class Code
    attr_accessor :listing
    
    def initialize(rawCode=nil)
      @listing = rawCode || "block"
    end
    
  end
end
module Nudge
  
  class Individual
    attr_accessor :genome, :scores
    attr_reader :timestamp
    
    def initialize(listing)
      @genome = listing
      @scores = Hash.new
      @timestamp = Time.now
    end
  end
end
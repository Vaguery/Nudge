module Nudge
  
  class Individual
    @@initialID = 0
    
    def identify
      @uniqueID = @@initialID += 1
    end
    
    attr_accessor :genome, :scores, :age, :ancestors, :location
    attr_reader :timestamp, :uniqueID
    
    def initialize(listing)
      self.identify
      @genome = listing
      @scores = Hash.new
      @timestamp = Time.now
      @age = 0
      @ancestors = []
      @location = 0
    end
  end
end
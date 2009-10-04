module Nudge
  
  class Individual
    @@initialID = 0
    
    def identify
      @uniqueID = @@initialID += 1
    end
    
    attr_accessor :genome, :scores, :age, :ancestors, :location, :program
    attr_reader :timestamp, :uniqueID
    
    def initialize(listing)
      self.identify
      @genome = listing
      @program = NudgeLanguageParser.new.parse(genome).to_points
      @scores = Hash.new
      @timestamp = Time.now
      @age = 0
      @ancestors = []
      @location = 0
    end
  end
end
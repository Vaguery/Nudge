module Nudge
  
  class Individual    
    attr_accessor :genome, :scores, :age, :ancestors, :location, :program
    attr_reader :timestamp, :id
    
    def initialize(listing)
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
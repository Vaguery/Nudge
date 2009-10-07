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
    
    def known_scores
      return self.scores.keys.sort
    end
    
    def score_vector(template = self.known_scores)
      vector = []
      template.each {|obj| vector << self.scores[obj]}
      return vector
    end
    
    def dominated_by?(other, template = self.known_scores)
      noWorse = true
      somewhatBetter = false
      template.each do |score|
        if self.scores[score] && other.scores[score]
          noWorse &&= (self.scores[score] >= other.scores[score])
          somewhatBetter ||= (self.scores[score] > other.scores[score])
        else
          return false
        end
      end
      return noWorse && somewhatBetter
    end
  end
end
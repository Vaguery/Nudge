module Nudge
  
  class Individual
    def self.helperParser
      @helperParser ||= NudgeLanguageParser.new()
    end
      
    attr_accessor :genome, :scores, :age, :ancestors, :station, :program
    attr_reader :timestamp, :id
    
    def initialize(listing)
      @helperParser = 
      
      @genome = listing
      raise(ArgumentError, "Nudge program cannot be parsed") if Individual.helperParser.parse(genome) == nil
      @program = Individual.helperParser.parse(genome).to_points
      @scores = Hash.new
      @timestamp = Time.now
      @age = 0
      @ancestors = []
      @station = ""
      
    end
    
    def known_scores
      return self.scores.keys.sort
    end
    
    def points
      return self.program.points
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
    
    
    def delete_point(which)
      return self.program.listing if (which < 1 || which > self.program.points)
      return "block {}" if which == 1
      chunks = isolate_point(which)
      variant = chunks[:left] + chunks[:right]
      return variant
    end
    
    
    def replace_point(which, newCode = "")
      raise(ArgumentError, "program points can only be replaced by nonempty strings") if newCode == ""
      return self.program.listing if (which < 1 || which > self.program.points)
      chunks = isolate_point(which)
      variant =  (chunks[:left] || "") + " #{newCode} " + (chunks[:right] || "")
      return variant
    end
    
    
    def isolate_point(which)
      raise(ArgumentError, "point specified is out of range in this genome") if
        (which < 1 || which > self.program.points)
      result = {}
      
      # we're going to work in an array so we can do abacus-like manipulations
      workingCopy = self.program.listing.split("\n")
      posn = which - 1
      
      # look at the point itself now
      # if it's a block, pull in more points from 'the right' until the braces balance here
      if workingCopy[posn].include?("block")
        leftCount = workingCopy[posn].count("{")
        rightCount = workingCopy[posn].count("}")
        while leftCount > rightCount do
          workingCopy[posn] += (workingCopy[posn+1])
          workingCopy.delete_at(posn+1)
          leftCount = workingCopy[posn].count("{")
          rightCount = workingCopy[posn].count("}")
        end
      end
      
      # whether the point is a block or not, we want to avoid taking extra closing braces
      # so we will peel off extra right braces into new elements in our workingCopy array
      leftCount = workingCopy[posn].count("{")
      rightCount = workingCopy[posn].count("}")
      while leftCount < rightCount do
        workingCopy[posn] = workingCopy[posn].strip
        workingCopy = workingCopy.insert(posn+1,"}")
        workingCopy[posn] = workingCopy[posn].chomp("}")
        leftCount = workingCopy[posn].count("{")
        rightCount = workingCopy[posn].count("}")
      end
      
      # we'll return an array of three strings
      # everything in the genome to the left of the point
      # the isolated point itself
      # everything to the right of the point from the genome
      # noting that if which==1, we will have empty left & right, and return the entire codeblock
      result[:middle] = workingCopy[posn]
      if which > 1
        result[:left] = workingCopy[0..posn-1].join
        result[:right] = workingCopy[posn+1..-1].join
      end
      return result
    end
  end
end
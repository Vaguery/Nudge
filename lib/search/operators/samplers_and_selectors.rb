module Nudge
  
  class Sampler < SearchOperator
    def initialize (params = {})
      super
    end
    
    def all_known_scores(crowd)
      union = []
      crowd.each do |dude|
        union |= dude.known_scores
      end
      return union
    end
    
    
    def all_shared_scores(crowd)
      intersection = self.all_known_scores(crowd)
      crowd.each do |dude|
        intersection = intersection & dude.known_scores
      end
      return intersection
    end
    
    def domination_classes(crowd, template = all_shared_scores(crowd))
      result = Hash.new()
      crowd.each_index do |i|
        dominatedBy = 0
        crowd.each_index do |j|
          dominatedBy += 1 if crowd[i].dominated_by?(crowd[j], template)
        end
        result[dominatedBy] ||= []
        result[dominatedBy].push crowd[i]
      end
      return result
    end
    
  end
  
  
  class NondominatedSubsetSelector < Sampler
    
    def generate(crowd, template = all_shared_scores(crowd))
      result = Batch.new
      crowd.each do |dude|
        dominated = false
        crowd.each do |otherDude|
          dominated ||= dude.dominated_by?(otherDude, template)
        end
        if !dominated
          result << dude
        end
      end
      return result
    end
  end
  
  
  class DominatedQuantileSampler < Sampler
    
    def generate(crowd, proportion = 0.5, template = all_shared_scores(crowd))
      classified = domination_classes(crowd, template)
      increasing_grades = classified.keys.sort {|a,b| b <=> a}
      partial_ordering = []
      increasing_grades.each {|grade| partial_ordering += classified[grade]}
      how_many = crowd.length * proportion
      
      result = Batch.new
      partial_ordering[0..how_many-1].each {|dude| result << dude} unless how_many == 0
      return result
    end
  end
  
  
  
  
  
  class MostDominatedSubsetSampler < Sampler
    def generate(crowd, template = all_shared_scores(crowd))
      result = Batch.new
      classified = domination_classes(crowd, template)
      worst_key = classified.keys.sort[-1]
      classified[worst_key].each {|bad_dude| result.push bad_dude}
      return result
    end
  end
end
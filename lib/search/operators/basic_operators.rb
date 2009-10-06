module Nudge

  class SearchOperator
  end
  
  
  class RandomGuess < SearchOperator
    def generate(params={}, howMany = 1)
      result = []
      howMany.times do
        newGenome = CodeType.random_value(params)
        newDude = Individual.new(newGenome)
        result << newDude
      end
      return result
    end
  end
  
  
  class RandomResample < SearchOperator
    def generate(crowd, howMany = 1)
      result = []
      howMany.times do
        which = rand(crowd.length)
        newGenome = crowd[which].genome.clone
        newDude = Individual.new(newGenome)
        result << newDude
      end
      return result
    end
  end
  
  class NondominatedSubset < SearchOperator
  end
end
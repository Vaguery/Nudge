module Nudge
  class SearchOperator
  end
  
  
  class RandomGuess < SearchOperator
    def generate(params={})
      newGenome = CodeType.random_value(params)
      newDude = Individual.new(newGenome)
      return newDude
    end
  end
  
  
  class RandomSample < SearchOperator
    def generate(crowd)
      which = rand(crowd.length)
      newGenome = crowd[which].genome.clone
      newDude = Individual.new(newGenome)
      return newDude
    end
  end
  
  class NondominatedSubset < SearchOperator
    def generate(crowd, objectives)
    end
  end
end
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
end
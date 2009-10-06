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
  
  class UniformBackboneCrossover < SearchOperator
    def generate(crowd, howMany = crowd.length, prob = 0.5)
      result = []
      howMany.times do
        where = rand(crowd.length)
        mom = crowd[where]
        dad = crowd[ (where+1) % crowd.length ]
        xover = "block {\n"
        (0..mom.program.contents.length-1).each do |point|
          if rand() < prob
            xover << mom.program.contents[point].tidy + "\n"
          else
            begin
              xover << dad.program.contents[point].tidy + "\n"
            rescue
              xover << mom.program.contents[point].tidy + "\n"
            end
          end
        end
        xover << "}"
        result << Individual.new(xover)
      end
      return result
    end
  end
end
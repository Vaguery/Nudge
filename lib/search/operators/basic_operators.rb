module Nudge

  # Abstract class that from which specific SearchOperator subclasses inherit initialization
  
  class SearchOperator
    attr_accessor :params

     def initialize(params={})
       @params = params
     end
  end
  
  
  
  class RandomGuess < SearchOperator
    # returns an Array of random Individuals
    #
    # the first (optional) parameter specifies how many to make, and defaults to 1
    # the second (also optional) parameter is a hash or set of hash bindings that
    # temporarily override those set in the initialization
    #
    # For example, if
    # <tt>myRandomGuesser = RandomGuess.new(:randomIntegerLowerBound => -90000)</tt>
    #
    # [<tt>myRandomGuesser.generate()</tt>]
    #   produces a list of 1 Individual, and if it has any IntType samples they will be in [-90000,100]
    #   (since the default +:randomIntegerLowerBound+ is 100)
    # [<tt>myRandomGuesser.generate(1,:randomIntegerLowerBound => 0)</tt>]
    #   makes one Individual whose IntType samples (if any) will be between [0,100]
    
    def generate(howMany = 1, tempParams ={})
      result = []
      howMany.times do
        newGenome = CodeType.random_value(@params.merge(tempParams))
        newDude = Individual.new(newGenome)
        result << newDude
      end
      result
    end
  end
  
  
  class PopulationResample < SearchOperator
    # returns an Array of clones of Individuals randomly selected from the crowd passed in
    # 
    # the first (required) parameter is an Array of Individuals
    # the second (optional) parameter is how many samples to take, and defaults to 1
    #
    # For example, if
    # <tt>@currentPopulation = [a list of 300 Individuals]</tt> and
    # <tt>myRandomSampler = PopulationResample.new(@currentPopulation)</tt>
    # [<tt>myRandomSampler.generate()</tt>]
    #   produces a list of 1 Individual, which is a clone of somebody from <tt>@currentPopulation</tt>
    # [<tt>myRandomGuesser.generate(11)</tt>]
    #   returns a list of 11 Individuals cloned from <tt>@currentPopulation</tt>,
    #   possibly including repeats
    
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
  
  
  class ResampleValues < SearchOperator
    
    # returns an Array of clones of Individuals randomly selected from the crowd passed in
    #   the first (required) parameter is an Array of Individuals
    #   the second (optional) parameter is how many samples to take, and defaults to 1
    #
    #   For example, if
    #     @currentPopulation = [a list of 300 Individuals]
    #     myRandomSampler = PopulationResample.new(@currentPopulation)
    #     myRandomSampler.generate()::
    #       produces a list of 1 Individual, which is a clone of somebody from @currentPopulation
    #     myRandomGuesser.generate(11)::
    #       returns a list of 11 Individuals cloned from @currentPopulation, possibly including repeats
    
    def generate(crowd, howManyCopies = 1, parameter_overrides = {})
      crowd.each {|dude| raise(ArgumentError) if !dude.kind_of?(Individual) }
      
      result = []
      tempParams = @params.merge(parameter_overrides)
      crowd.each do |dude|
        wildtype = dude.program.listing
        howManyCopies.times do
          novelty = ""
          wildtype.each_line do |line|
            line = line.sub(/\((.*)\)/,
              "(#{IntType.random_value(tempParams)})") if line.include?("sample int")
            line = line.sub(/\((.*)\)/,
              "(#{BoolType.random_value(tempParams)})") if line.include?("sample bool")
            line = line.sub(/\((.*)\)/,
              "(#{FloatType.random_value(tempParams)})") if line.include?("sample float")
            novelty << line
          end
          mutant = Individual.new(novelty)
          result << mutant
        end
      end
      result
    end
  end
  
  
  
  class NondominatedSubset < SearchOperator
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
    
    
    def generate(crowd, template = all_shared_scores(crowd))
      result = []
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
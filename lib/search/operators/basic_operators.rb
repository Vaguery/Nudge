module Nudge

  # Abstract class that from which specific SearchOperator subclasses inherit initialization
  
  class SearchOperator
    attr_accessor :options

     def initialize(options={})
       @options = options
     end
  end
  
  
  
  class RandomGuessOperator < SearchOperator
    attr_accessor :incoming_options
    attr_accessor :code_generator
    
    def initialize(options ={})
      @incoming_options = options
      @code_generator = StringRewritingGenerator.new(options)
    end
    
    # returns an Array of random Individuals
    #
    # the first (optional) parameter specifies how many to make, and defaults to 1
    # the second (also optional) parameter is a hash that
    # can temporarily override those set in the initialization
    #
    # For example, if
    # <tt>myRandomGuesser = RandomGuessOperator.new(:randomIntegerLowerBound => -90000)</tt>
    #
    # [<tt>myRandomGuesser.generate()</tt>]
    #   produces a list of 1 Individual, and if it has any IntType samples they will be in [-90000,100]
    #   (since the default +:randomIntegerLowerBound+ is 100)
    # [<tt>myRandomGuesser.generate(1,:randomIntegerLowerBound => 0)</tt>]
    #   makes one Individual whose IntType samples (if any) will be between [0,100]
    
    def generate(howMany = 1, overridden_options ={})
      result = Batch.new
      howMany.times do
        newGenome = CodeType.any_value(@incoming_options.merge(overridden_options))
        newDude = Individual.new(newGenome)
        newDude.progress = 0
        result << newDude
      end
      result
    end
  end
  
  
  class ResampleAndCloneOperator < SearchOperator
    # returns an Array of clones of Individuals randomly selected from the crowd passed in
    # 
    # the first (required) parameter is an Array of Individuals
    # the second (optional) parameter is how many samples to take, and defaults to 1
    #
    # For example, if
    # <tt>@currentPopulation = [a list of 300 Individuals]</tt> and
    # <tt>myRandomSampler = ResampleAndCloneOperator.new(@currentPopulation)</tt>
    # [<tt>myRandomSampler.generate()</tt>]
    #   produces a list of 1 Individual, which is a clone of somebody from <tt>@currentPopulation</tt>
    # [<tt>myRandomGuesser.generate(11)</tt>]
    #   returns a list of 11 Individuals cloned from <tt>@currentPopulation</tt>,
    #   possibly including repeats
    
    def generate(crowd, howMany = 1)
      result = Batch.new
      howMany.times do
        donor = crowd.sample
        newGenome = donor.genome.clone
        newDude = Individual.new(newGenome)
        newDude.progress = donor.progress + 1
        result << newDude
      end
      return result
    end
  end
  
  
  class ResampleValuesOperator < SearchOperator
    
    # returns an Array of clones of Individuals randomly selected from the crowd passed in
    #   the first (required) parameter is an Array of Individuals
    #   the second (optional) parameter is how many samples to take, and defaults to 1
    #
    #   For example, if
    #     @currentPopulation = [a list of 300 Individuals]
    #     myRandomSampler = ResampleAndCloneOperator.new(@currentPopulation)
    #     myRandomSampler.generate()::
    #       produces a list of 1 Individual, which is a clone of somebody from @currentPopulation
    #     myRandomGuesser.generate(11)::
    #       returns a list of 11 Individuals cloned from @currentPopulation, possibly including repeats
    
    def generate(crowd, howManyCopies = 1, parameter_overrides = {})
      crowd.each {|dude| raise(ArgumentError) if !dude.kind_of?(Individual) }
      
      result = Batch.new
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
          mutant.progress = dude.progress + 1
          result << mutant
        end
      end
      result
    end
  end
  
  
  # Returns a Batch of new Individuals whose programs are made by stitching together
  # the programs of pairs of 'parents'. The incoming Batch is divided into pairs based on
  # adjacency (modulo the Batch.length), one pair for each 'offspring' to be made. To make
  # an offspring, the number of backbone program points is determined in each parent; 'backbone'
  # refers to the number of branches directly within the root of the program, not the entire tree.
  #
  # To construct an offspring's program, program points are copied from the first parent with
  # probability p, or the second parent with probability (1-p), for each point in the first
  # parent's backbone. So if there are 13 and 6 points, respectively, the first six points are
  # selected randomly, but the last 7 are copied from the first parent. If there are 8 and 11
  # respectively, then the last 3 will be ignored from the second parent in any case.
  #   
  #   the first (required) parameter is an Array of Individuals
  #   the second (optional) parameter is how many crossovers to make,
  #     which defaults to the number of Individuals in the incoming Batch
  
  
  class UniformBackboneCrossoverOperator < SearchOperator
    def generate(crowd, howMany = crowd.length, prob = 0.5)
      result = Batch.new
      howMany.times do
        where = rand(crowd.length)
        mom = crowd[where]
        dad = crowd[ (where+1) % crowd.length ]
        mom_length = mom.program[1].contents.length
        dad_length = dad.program[1].contents.length
        
        (0...mom.program[0].contents.length).each do |point|
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
        baby = Individual.new(xover)
        baby.progress = [mom.progress,dad.progress].max + 1
        
        result << baby
      end
      return result
    end
  end
  
  
  
  class PointCrossoverOperator < SearchOperator
    def generate(crowd, howManyBabies = 1)
      raise(ArgumentError) if !crowd.kind_of?(Array)
      raise(ArgumentError) if crowd.empty?
      crowd.each {|dude| raise(ArgumentError) if !dude.kind_of?(Individual) }
      
      result = Batch.new
      production = crowd.length*howManyBabies
      production.times do
        mom = crowd.sample
        dad = crowd.sample
        momSplit = mom.isolate_point(rand(mom.points)+1)
        dadSplit = dad.isolate_point(rand(dad.points)+1)
        babyGenome = (momSplit[:left] || "") + " #{dadSplit[:middle]} " + (momSplit[:right] || "")
        baby = Individual.new(babyGenome)
        baby.progress = [mom.progress,dad.progress].max + 1
        result << baby
      end
      return result
    end
  end
  
  
  
  
  class PointDeleteOperator < SearchOperator
    def generate(crowd, howManyCopies = 1)
      raise(ArgumentError) if !crowd.kind_of?(Array)
      crowd.each {|dude| raise(ArgumentError) if !dude.kind_of?(Individual) }
      
      result = Batch.new
      crowd.each do |dude|
        howManyCopies.times do
          where = rand(dude.points)+1
          variant = dude.delete_point(where)
          baby = Individual.new(variant)
          baby.progress = dude.progress + 1
          result << baby
        end
      end
      return result
    end
  end
  
  
  
  class PointMutationOperator < SearchOperator
    attr_accessor :context
    
    def initialize(params ={})
      @context = InterpreterSettings.new(:instructions => params[:instructions],
        :references => params[:references], :types => params[:types])
      super
    end
    
    def generate(crowd, howManyCopies = 1, tempParams ={})
      raise(ArgumentError) if !crowd.kind_of?(Array)
      raise(ArgumentError) if crowd.empty?
      crowd.each {|dude| raise(ArgumentError) if !dude.kind_of?(Individual) }
      
      result = Batch.new
      crowd.each do |dude|
        howManyCopies.times do
          where = rand(dude.points)+1
          newCode = CodeType.random_value(@context, @params.merge(tempParams))
          variant = dude.replace_point(where,newCode)
          baby = Individual.new(variant)
          baby.progress = dude.progress + 1
          result << baby 
        end
      end
      return result
    end
  end
end
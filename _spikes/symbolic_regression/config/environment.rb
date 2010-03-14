
Nudge::Config.setup do |factory|
  
  # set up instructions
  factory.instructions =
    [99]
    
  
  # set up variable names
  factory.variable_names = ["x1", "x2"]
  
  # set up types
  factory.types = ["int", "bool", "float", "code"]
  
  # set up stations
  factory.build_station("generator1",
    :capacity => 1,
    :cull_trigger => Proc.new {false},
    :generate_rule => Proc.new {|placeholder| RandomGuessOperator.new(
        :reference_names => factory.variable_names,
        :type_names => factory.types).generate(1,:target_size_in_points => rand(50)+10)
      },
    :promotion_rule => Proc.new {|anybody| true}
  )
    
  factory.build_station("generator2",
    :capacity => 1,
    :cull_trigger => Proc.new {false},
    :generate_rule => Proc.new {|placeholder| RandomGuessOperator.new(
        :reference_names => factory.variable_names,
        :type_names => factory.types).generate(1,:target_size_in_points => rand(20)+10)
      },
    :promotion_rule => Proc.new {|anybody| true}
  )
  
  factory.build_station("level1",
    :capacity => 100,
    :generate_rule => Proc.new do |pop|
      if pop.length > 80
        bw = pop.minmax {|a,b| (a.scores["errors11"] || 10000) <=> (b.scores["errors11"] || 10000) }
        # bw.each {|dude| puts "#{dude.progress}: #{dude.scores} [#{dude.genome}]\n\n"}
        
        mySampler = ResampleAndCloneOperator.new
        myCrossover = PointCrossoverOperator.new
        myMutator = PointMutationOperator.new(
        type_names:factory.types,
        reference_names:factory.variable_names)
        mySelector = NondominatedSubsetSelector.new
        myEvaluator = TestCaseEvaluator.new(
        :name => "errors11",
          type_names:factory.types,
          reference_names:factory.variable_names
          )
        myPointsEvaluator = ProgramPointEvaluator.new(:name => "points")
        myCases = (-5..5).collect do |i|
          TestCase.new(:bindings => {"x1" => ValuePoint.new("int",i)},
            :expectations => {"y" => 2*i*i*i - 8*i*i + 6 * i + 91},
            :gauges => {"y" => Proc.new {|interp| interp.stacks[:int].peek}}
          )
        end
      
        newGuys = Batch.new
        5.times do
          puts "#{pop.length}\n"
          tourney = mySampler.generate(pop,4) # pick dudes at random from the population
          tourney = myEvaluator.evaluate(tourney, myCases, deterministic:true) # evaluate them
          tourney = myPointsEvaluator.evaluate(tourney)
        
          babies = myCrossover.generate(tourney, 1) # create 1 babies from those
          babies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate them
          babies = myPointsEvaluator.evaluate(babies)
        
          mutantBabies = myMutator.generate(babies, 2) # make 1 mutants of the babies
          mutantBabies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate
          mutantBabies = myPointsEvaluator.evaluate(mutantBabies)
        
          bestInShow = mySelector.generate(tourney + babies + mutantBabies, template:["errors11"])
          newGuys += bestInShow # retain only the best
          
          bestInShow.each {|dude| puts "#{dude.scores}, progress:#{dude.progress}"}
        end        
        newGuys
      else
        Batch.new
      end
    end,
    :promotion_rule => Proc.new {|dude| dude.progress > 10}
  )
  
  factory.build_station("level2",
    :capacity => 100,
    :generate_rule => Proc.new do |pop|

      if pop.length > 70
        bw = pop.minmax {|a,b| (a.scores["errors21"] || 10000) <=> (b.scores["errors21"] || 10000) }
        # bw.each {|dude| puts "#{dude.progress}: #{dude.scores} [#{dude.genome}]\n\n"}
        
        mySampler = ResampleAndCloneOperator.new
        myCrossover = PointCrossoverOperator.new
        myMutator = PointMutationOperator.new(
        type_names:factory.types,
        reference_names:factory.variable_names)
        
        mySelector = NondominatedSubsetSelector.new
        myEvaluator = TestCaseEvaluator.new(
          :name => "errors21",
          type_names:factory.types,
          reference_names:factory.variable_names
        )
        myPointsEvaluator = ProgramPointEvaluator.new(:name => "points")
        
        myCases = (-10..10).collect do |i|
          TestCase.new(
            :bindings => {"x1" => ValuePoint.new("int",i)},
            :expectations => {"y" => 2*i*i*i - 8*i*i + 6 * i + 91},
            :gauges => {"y" => Proc.new {|interp| interp.stacks[:int].peek}}
          )
        end
      
        newGuys = Batch.new
        5.times do
          puts "#{pop.length}\n"
          tourney = mySampler.generate(pop,6) # pick 6 dudes at random from the population
          tourney = myEvaluator.evaluate(tourney, myCases, deterministic:true) # evaluate them
          tourney = myPointsEvaluator.evaluate(tourney)
        
          babies = myCrossover.generate(tourney, 2) # create 2 babies from those
          babies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate them
          babies = myPointsEvaluator.evaluate(babies)
        
          mutantBabies = myMutator.generate(babies, 2) # make 2 mutants of the babies
          mutantBabies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate
          mutantBabies = myPointsEvaluator.evaluate(mutantBabies)
        
          bestInShow = mySelector.generate(tourney + babies + mutantBabies, template:["errors21"])
          newGuys += bestInShow # retain only the best
          
          bestInShow.each {|dude| puts "#{dude.scores}, progress:#{dude.progress}"}
        end
        newGuys
      else
        Batch.new
      end
    end,
    :promotion_rule => Proc.new {|dude| dude.progress > 20}
  )
  
  
  factory.build_station("level3",
    :capacity => 100,
    :generate_rule => Proc.new do |pop|

      if pop.length > 70
        bw = pop.minmax {|a,b| (a.scores["errors31"] || 10000) <=> (b.scores["errors31"] || 10000) }
        # bw.each {|dude| puts "#{dude.progress}: #{dude.scores} [#{dude.genome}]\n\n"}

        mySampler = ResampleAndCloneOperator.new
        myCrossover = PointCrossoverOperator.new
        myMutator = PointMutationOperator.new(
        type_names:factory.types,
        reference_names:factory.variable_names)
        
        mySelector = NondominatedSubsetSelector.new
        myEvaluator = TestCaseEvaluator.new(
          :name => "errors31",
          type_names:factory.types,
          reference_names:factory.variable_names)
        myPointsEvaluator = ProgramPointEvaluator.new(:name => "points")
        
        myCases = (-20..10).collect do |i|
          TestCase.new(
            :bindings => {"x1" => ValuePoint.new("int",i)},
            :expectations => {"y" => 2*i*i*i - 8*i*i + 6 * i + 91},
            :gauges => {"y" => Proc.new {|interp| interp.stacks[:int].peek}}
          )
        end
      
        newGuys = Batch.new
        5.times do
          puts "#{pop.length}\n"
          tourney = mySampler.generate(pop,8) # pick 8 dudes at random from the population
          tourney = myEvaluator.evaluate(tourney, myCases, deterministic:true) # evaluate them
          tourney = myPointsEvaluator.evaluate(tourney)
        
          babies = myCrossover.generate(tourney, 2) # create 2 babies from those
          babies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate them
          babies = myPointsEvaluator.evaluate(babies)
        
          mutantBabies = myMutator.generate(babies, 2) # make 2 mutants of the babies
          mutantBabies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate
          mutantBabies = myPointsEvaluator.evaluate(mutantBabies)
        
          bestInShow = mySelector.generate(tourney + babies + mutantBabies, template:["errors31"])
          newGuys += bestInShow # retain only the best
          
          bestInShow.each {|dude| puts "#{dude.scores}, progress:#{dude.progress}"}
        end
        newGuys
      else
        Batch.new
      end
    end,
    :promotion_rule => Proc.new {|dude| dude.progress > 30}
  )
  
  
  factory.build_station("level4",
    :capacity => 100,
    :generate_rule => Proc.new do |pop|
      
      if pop.length > 70
        bw = pop.minmax {|a,b| (a.scores["errors41"] || 10000) <=> (b.scores["errors41"] || 10000) }
        # bw.each {|dude| puts "#{dude.progress}: #{dude.scores} [#{dude.genome}]\n\n"}
        mySampler = ResampleAndCloneOperator.new
        myCrossover = PointCrossoverOperator.new
        myMutator = PointMutationOperator.new(
        type_names:factory.types,
        reference_names:factory.variable_names)
        
        mySelector = NondominatedSubsetSelector.new()
        myEvaluator = TestCaseEvaluator.new(
          :name => "errors41",
          type_names:factory.types,
          reference_names:factory.variable_names
        )
        myPointsEvaluator = ProgramPointEvaluator.new(:name => "points")
        
        myCases = (-20..20).collect do |i|
          TestCase.new(
            :bindings => {"x1" => ValuePoint.new("int",i)},
            :expectations => {"y" => 2*i*i*i - 8*i*i + 6 * i + 91},
            :gauges => {"y" => Proc.new {|interp| interp.stacks[:int].peek}}
          )
        end
      
        newGuys = Batch.new
        5.times do
          puts "#{pop.length}\n"
          tourney = mySampler.generate(pop,6) # pick 6 dudes at random from the population
          tourney = myEvaluator.evaluate(tourney, myCases, deterministic:true) # evaluate them
          tourney = myPointsEvaluator.evaluate(tourney)

          babies = myCrossover.generate(tourney, 10) # create 10 babies from those
          babies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate them
          babies = myPointsEvaluator.evaluate(babies)

          mutantBabies = myMutator.generate(babies, 10) # make 10 mutants of the babies
          mutantBabies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate
          mutantBabies = myPointsEvaluator.evaluate(mutantBabies)

          bestInShow = mySelector.generate(tourney + babies + mutantBabies)
          newGuys += bestInShow # retain only the best
          
          bestInShow.each {|dude| puts "#{dude.scores}, progress:#{dude.progress}"}
        end
        newGuys
      else
        Batch.new
      end
    end,
    :promotion_rule => Proc.new {|anybody| false}
  )
  
  
  
  
  factory.connect_stations("generator1", "level1")
  factory.connect_stations("generator2", "level1")
  factory.connect_stations("level1", "level2")
  factory.connect_stations("level2", "level3")
  factory.connect_stations("level3", "level4")
  
end

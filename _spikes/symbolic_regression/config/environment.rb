Nudge::Config.setup do |experiment|
  
  # set up instructions
  experiment.instructions =
    [99]
    
  
  # set up variable names
  experiment.variable_names = ["x1", "x2"]
  
  # set up types
  experiment.types = [IntType, BoolType]
  
  # set up stations
  experiment.build_station("generator1",
    :capacity => 1,
    :cull_trigger => Proc.new {false},
    :generate_rule => Proc.new {|placeholder| RandomGuessOperator.new(
        :instructions => experiment.instructions,
        :references => experiment.variable_names,
        :types => experiment.types).generate(1,:points => rand(20)+10)
      },
    :promotion_rule => Proc.new {|anybody| true}
  )
    
  experiment.build_station("generator2",
    :capacity => 1,
    :cull_trigger => Proc.new {false},
    :generate_rule => Proc.new {|placeholder| RandomGuessOperator.new(
        :instructions => experiment.instructions,
        :references => experiment.variable_names,
        :types => experiment.types).generate(1,:points => rand(30)+20)
      },
    :promotion_rule => Proc.new {|anybody| true}
  )
  
  experiment.build_station("level1",
    :capacity => 100,
    :generate_rule => Proc.new do |pop|
      if pop.length > 80
        bw = pop.minmax {|a,b| (a.scores["errors"] || 10000) <=> (b.scores["errors"] || 10000) }
        bw.each {|dude| puts "#{dude.progress}: #{dude.scores} [#{dude.genome}]\n\n"}
        
        mySampler = ResampleAndCloneOperator.new
        myCrossover = PointCrossoverOperator.new
        myMutator = PointMutationOperator.new(
        instructions:[IntModuloInstruction, IntMultiplyInstruction, IntAddInstruction,IntSubtractInstruction,
        IntDivideInstruction, IntLessThanQInstruction, IntEqualQInstruction, IntGreaterThanQInstruction,
        IntDuplicateInstruction, IntFlushInstruction, IntFromBoolInstruction, IntMaxInstruction,
        IntMinInstruction, IntPopInstruction, IntRotateInstruction,IntShoveInstruction,
        IntDepthInstruction, IntSwapInstruction, IntYankInstruction, IntYankdupInstruction,IntAbsInstruction,
        IntIfInstruction, IntNegativeInstruction, BoolEqualQInstruction, BoolAndInstruction,
        BoolDuplicateInstruction, BoolFlushInstruction, BoolFromIntInstruction, BoolNotInstruction,
        BoolOrInstruction, BoolPopInstruction, BoolRotateInstruction,
        BoolShoveInstruction, BoolDepthInstruction, BoolSwapInstruction, BoolYankInstruction,
        BoolYankdupInstruction, BoolXorInstruction],
        types:[IntType, BoolType],
        references:["x1","x2"])
        mySelector = NondominatedSubsetSelector.new
        myEvaluator = TestCaseEvaluator.new(
        :name => "errors",
        :instructions =>
          [IntModuloInstruction, IntMultiplyInstruction, IntAddInstruction,IntSubtractInstruction,
          IntDivideInstruction, IntLessThanQInstruction, IntEqualQInstruction, IntGreaterThanQInstruction,
          IntDuplicateInstruction, IntFlushInstruction, IntFromBoolInstruction, IntMaxInstruction,
          IntMinInstruction, IntPopInstruction, IntRotateInstruction,IntShoveInstruction,
          IntDepthInstruction, IntSwapInstruction, IntYankInstruction,
          IntYankdupInstruction,IntAbsInstruction, IntIfInstruction, IntNegativeInstruction,
          BoolEqualQInstruction, BoolAndInstruction,
          BoolDuplicateInstruction, BoolFlushInstruction, BoolFromIntInstruction, BoolNotInstruction,
          BoolOrInstruction, BoolPopInstruction, BoolRotateInstruction,
          BoolShoveInstruction, BoolDepthInstruction, BoolSwapInstruction, BoolYankInstruction,
          BoolYankdupInstruction, BoolXorInstruction],
          :references => ["x1", "x2"],
          :types => [IntType, BoolType]
          )
        myPointsEvaluator = ProgramPointEvaluator.new(:name => "points")
        myCases = (-10..10).collect do |i|
          TestCase.new(:bindings => {"x1" => LiteralPoint.new("int",i)},
            :expectations => {"y" => 2*i*i*i - 8*i*i + 6 * i + 91},
            :gauges => {"y" => Proc.new {|interp| interp.stacks[:int].peek}}
          )
        end
      
        newGuys = Batch.new
        10.times do
          puts "."
          tourney = mySampler.generate(pop,10) # pick 10 dudes at random from the population
          tourney = myEvaluator.evaluate(tourney, myCases, deterministic:true) # evaluate them
          tourney = myPointsEvaluator.evaluate(tourney)
        
          babies = myCrossover.generate(tourney, 1) # create 1 babies from those
          babies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate them
          babies = myPointsEvaluator.evaluate(babies)
        
          mutantBabies = myMutator.generate(babies, 2) # make 1 mutants of the babies
          mutantBabies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate
          mutantBabies = myPointsEvaluator.evaluate(mutantBabies)
        
          bestInShow = mySelector.generate(tourney + babies + mutantBabies)
          newGuys += bestInShow # retain only the best
        end        
        newGuys
      else
        Batch.new
      end
    end,
    :promotion_rule => Proc.new {|dude| dude.progress > 10}
  )
  
  experiment.build_station("level2",
    :capacity => 100,
    :generate_rule => Proc.new do |pop|

      if pop.length > 70
        bw = pop.minmax {|a,b| (a.scores["errors"] || 10000) <=> (b.scores["errors"] || 10000) }
        bw.each {|dude| puts "#{dude.progress}: #{dude.scores} [#{dude.genome}]\n\n"}
        
        mySampler = ResampleAndCloneOperator.new
        myCrossover = PointCrossoverOperator.new
        myMutator = PointMutationOperator.new(
        instructions:[IntAddInstruction, IntSubtractInstruction,
          IntMultiplyInstruction, IntDivideInstruction],
        types:[IntType, BoolType],
        references:["x1","x2"])
        
        mySelector = NondominatedSubsetSelector.new
        myEvaluator = TestCaseEvaluator.new(
          :name => "errors",
          :instructions =>
          [IntModuloInstruction, IntMultiplyInstruction, IntAddInstruction,IntSubtractInstruction,
          IntDivideInstruction, IntLessThanQInstruction, IntEqualQInstruction, IntGreaterThanQInstruction,
          IntDuplicateInstruction, IntFlushInstruction, IntFromBoolInstruction, IntMaxInstruction,
          IntMinInstruction, IntPopInstruction, IntRotateInstruction,IntShoveInstruction,
          IntDepthInstruction, IntSwapInstruction, IntYankInstruction,
          IntYankdupInstruction,IntAbsInstruction, IntIfInstruction, IntNegativeInstruction,
          BoolEqualQInstruction, BoolAndInstruction,
          BoolDuplicateInstruction, BoolFlushInstruction, BoolFromIntInstruction, BoolNotInstruction,
          BoolOrInstruction, BoolPopInstruction, BoolRotateInstruction,
          BoolShoveInstruction, BoolDepthInstruction, BoolSwapInstruction, BoolYankInstruction,
          BoolYankdupInstruction, BoolXorInstruction],
          :references => ["x1", "x2"],
          :types => [IntType, BoolType]
        )
        myPointsEvaluator = ProgramPointEvaluator.new(:name => "points")
        
        myCases = (-10..10).collect do |i|
          TestCase.new(
            :bindings => {"x1" => LiteralPoint.new("int",i)},
            :expectations => {"y" => 2*i*i*i - 8*i*i + 6 * i + 91},
            :gauges => {"y" => Proc.new {|interp| interp.stacks[:int].peek}}
          )
        end
      
        newGuys = Batch.new
        10.times do
          puts "."
          tourney = mySampler.generate(pop,8) # pick 6 dudes at random from the population
          tourney = myEvaluator.evaluate(tourney, myCases, deterministic:true) # evaluate them
          tourney = myPointsEvaluator.evaluate(tourney)
        
          babies = myCrossover.generate(tourney, 2) # create 2 babies from those
          babies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate them
          babies = myPointsEvaluator.evaluate(babies)
        
          mutantBabies = myMutator.generate(babies, 2) # make 2 mutants of the babies
          mutantBabies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate
          mutantBabies = myPointsEvaluator.evaluate(mutantBabies)
        
          bestInShow = mySelector.generate(tourney + babies + mutantBabies)
          newGuys += bestInShow # retain only the best
        end
        newGuys
      else
        Batch.new
      end
    end,
    :promotion_rule => Proc.new {|dude| dude.progress > 20}
  )
  
  
  experiment.build_station("level3",
    :capacity => 100,
    :generate_rule => Proc.new do |pop|

      if pop.length > 70
        bw = pop.minmax {|a,b| (a.scores["errors"] || 10000) <=> (b.scores["errors"] || 10000) }
        bw.each {|dude| puts "#{dude.progress}: #{dude.scores} [#{dude.genome}]\n\n"}

        mySampler = ResampleAndCloneOperator.new
        myCrossover = PointCrossoverOperator.new
        myMutator = PointMutationOperator.new(
        instructions:[IntAddInstruction, IntSubtractInstruction,
          IntMultiplyInstruction, IntDivideInstruction],
        types:[IntType, BoolType],
        references:["x1","x2"])
        
        mySelector = NondominatedSubsetSelector.new
        myEvaluator = TestCaseEvaluator.new(
          :name => "errors",
          :instructions =>
          [IntModuloInstruction, IntMultiplyInstruction, IntAddInstruction,IntSubtractInstruction,
          IntDivideInstruction, IntLessThanQInstruction, IntEqualQInstruction, IntGreaterThanQInstruction,
          IntDuplicateInstruction, IntFlushInstruction, IntFromBoolInstruction, IntMaxInstruction,
          IntMinInstruction, IntPopInstruction, IntRotateInstruction,IntShoveInstruction,
          IntDepthInstruction, IntSwapInstruction, IntYankInstruction,
          IntYankdupInstruction,IntAbsInstruction, IntIfInstruction, IntNegativeInstruction,
          BoolEqualQInstruction, BoolAndInstruction,
          BoolDuplicateInstruction, BoolFlushInstruction, BoolFromIntInstruction, BoolNotInstruction,
          BoolOrInstruction, BoolPopInstruction, BoolRotateInstruction,
          BoolShoveInstruction, BoolDepthInstruction, BoolSwapInstruction, BoolYankInstruction,
          BoolYankdupInstruction, BoolXorInstruction],
          :references => ["x1", "x2"],
          :types => [IntType, BoolType]
        )
        myPointsEvaluator = ProgramPointEvaluator.new(:name => "points")
        
        myCases = (-10..10).collect do |i|
          TestCase.new(
            :bindings => {"x1" => LiteralPoint.new("int",i)},
            :expectations => {"y" => 2*i*i*i - 8*i*i + 6 * i + 91},
            :gauges => {"y" => Proc.new {|interp| interp.stacks[:int].peek}}
          )
        end
      
        newGuys = Batch.new
        10.times do
          puts "."
          tourney = mySampler.generate(pop,8) # pick 8 dudes at random from the population
          tourney = myEvaluator.evaluate(tourney, myCases, deterministic:true) # evaluate them
          tourney = myPointsEvaluator.evaluate(tourney)
        
          babies = myCrossover.generate(tourney, 2) # create 2 babies from those
          babies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate them
          babies = myPointsEvaluator.evaluate(babies)
        
          mutantBabies = myMutator.generate(babies, 2) # make 2 mutants of the babies
          mutantBabies = myEvaluator.evaluate(babies, myCases, deterministic:true) # evaluate
          mutantBabies = myPointsEvaluator.evaluate(mutantBabies)
        
          bestInShow = mySelector.generate(tourney + babies + mutantBabies)
          newGuys += bestInShow # retain only the best
        end
        newGuys
      else
        Batch.new
      end
    end,
    :promotion_rule => Proc.new {|dude| dude.progress > 30}
  )
  
  
  experiment.build_station("level4",
    :capacity => 100,
    :generate_rule => Proc.new do |pop|
      
      if pop.length > 70
        bw = pop.minmax {|a,b| (a.scores["errors"] || 10000) <=> (b.scores["errors"] || 10000) }
        bw.each {|dude| puts "#{dude.progress}: #{dude.scores} [#{dude.genome}]\n\n"}
        mySampler = ResampleAndCloneOperator.new
        myCrossover = PointCrossoverOperator.new
        myMutator = PointMutationOperator.new(
        instructions:[IntAddInstruction, IntSubtractInstruction,
          IntMultiplyInstruction, IntDivideInstruction],
        types:[IntType, BoolType],
        references:["x1","x2"])
        
        mySelector = NondominatedSubsetSelector.new
        myEvaluator = TestCaseEvaluator.new(
          :name => "errors",
          :instructions =>
          [IntModuloInstruction, IntMultiplyInstruction, IntAddInstruction,IntSubtractInstruction,
          IntDivideInstruction, IntLessThanQInstruction, IntEqualQInstruction, IntGreaterThanQInstruction,
          IntDuplicateInstruction, IntFlushInstruction, IntFromBoolInstruction, IntMaxInstruction,
          IntMinInstruction, IntPopInstruction, IntRotateInstruction,IntShoveInstruction,
          IntDepthInstruction, IntSwapInstruction, IntYankInstruction,
          IntYankdupInstruction,IntAbsInstruction, IntIfInstruction, IntNegativeInstruction,
          BoolEqualQInstruction, BoolAndInstruction,
          BoolDuplicateInstruction, BoolFlushInstruction, BoolFromIntInstruction, BoolNotInstruction,
          BoolOrInstruction, BoolPopInstruction, BoolRotateInstruction,
          BoolShoveInstruction, BoolDepthInstruction, BoolSwapInstruction, BoolYankInstruction,
          BoolYankdupInstruction, BoolXorInstruction],
          :references => ["x1", "x2"],
          :types => [IntType, BoolType]
        )
        myPointsEvaluator = ProgramPointEvaluator.new(:name => "points")
        
        myCases = (-10..10).collect do |i|
          TestCase.new(
            :bindings => {"x1" => LiteralPoint.new("int",i)},
            :expectations => {"y" => 2*i*i*i - 8*i*i + 6 * i + 91},
            :gauges => {"y" => Proc.new {|interp| interp.stacks[:int].peek}}
          )
        end
      
        newGuys = Batch.new
        10.times do
          puts "."
          tourney = mySampler.generate(pop,2) # pick 2 dudes at random from the population
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
        end
        newGuys
      else
        Batch.new
      end
    end,
    :promotion_rule => Proc.new {|anybody| false}
  )
  
  
  
  
  experiment.connect_stations("generator1", "level1")
  experiment.connect_stations("generator2", "level1")
  experiment.connect_stations("level1", "level2")
  experiment.connect_stations("level2", "level3")
  experiment.connect_stations("level3", "level4")
  
end

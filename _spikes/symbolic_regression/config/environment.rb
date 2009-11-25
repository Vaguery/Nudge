Nudge::Config.setup do |experiment|
  
  # set up instructions
  experiment.instructions =
    [IntAddInstruction, IntSubtractInstruction, IntMultiplyInstruction, IntDivideInstruction]
  
  # set up variable names
  experiment.variable_names = ["x1", "x2"]
  
  # set up types
  experiment.types = [IntType, BoolType]
  
  # set up stations
  experiment.build_station("generator1",
    :capacity => 10,
    :cull_trigger => Proc.new {puts "  gen1 cull_trigger"; false},
    :generate_rule => Proc.new {|placeholder| puts "  gen1 generate_rule"; RandomGuessOperator.new(
        :instructions => experiment.instructions,
        :references => experiment.variable_names,
        :types => experiment.types).generate(10,:points => 50)
      },
    :promotion_rule => Proc.new {|anybody| puts "  gen1 promotion_rule"; true}
  )
    
  experiment.build_station("generator2",
    :capacity => 10,
    :cull_trigger => Proc.new {puts "  gen1 cull_trigger"; false},
    :generate_rule => Proc.new {|placeholder| puts "  gen2 generate_rule"; RandomGuessOperator.new(
        :instructions => experiment.instructions,
        :references => experiment.variable_names,
        :types => experiment.types).generate(10,:points => 30)
      },
    :promotion_rule => Proc.new {|anybody| puts "  gen1 promotion_rule"; true}
  )
  
  experiment.build_station("level1",
    :capacity => 100,
    :cull_trigger => Proc.new {puts "  lvl1 cull_trigger"; false},
    :generate_rule => Proc.new do |pop|
      puts "  level1 generate_rule"
      mySampler = PopulationResampleOperator.new
      myCrossover = PointCrossoverOperator.new
      myMutator = ResampleValuesOperator.new
      mySelector = NondominatedSubsetOperator.new
      myEvaluator = TestCaseEvaluator.new(
      :name => "errors",
      :instructions =>
        [IntAddInstruction, IntSubtractInstruction, IntMultiplyInstruction, IntDivideInstruction],
        :references => ["x1", "x2"],
        :types => [IntType, BoolType]
        )
      myCases = (1..10).collect do |i|
        TestCase.new(:bindings => {"x1" => LiteralPoint.new("int",i)},
          :expectations => {"y" => i*i + 6},
          :gauges => {"y" => Proc.new {|interp| interp.stacks[:int].peek}}
        )
      end
      
      newGuys = Batch.new
      10.times do
        tourney = mySampler.generate(pop,10) # pick 10 dudes at random from the population
        babies = myCrossover.generate(tourney) # create 10 babies from those
        mutantBabies = myMutator.generate(babies) # append 10 mutants of the babies
        muster = myEvaluator.evaluate(babies, myCases) # evaluate them
        newGuys = mySelector.generate(muster) # retain only the best
      end
      
      newGuys
    end,
    :promotion_rule => Proc.new {|anybody| false}
  )
  
  experiment.connect_stations("generator1", "level1")
  experiment.connect_stations("generator2", "level1")
  
end

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
    :promotion_rule => Proc.new {|anybody| false}
  )
  
  experiment.connect_stations("generator1", "level1")
  experiment.connect_stations("generator2", "level1")
  
end

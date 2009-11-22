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
    :cull_trigger => Proc.new {puts "  gen1 culling"; false})
    
  experiment.build_station("generator2",
    :capacity => 10,
    :cull_trigger => Proc.new {puts "  gen2 culling"; false})
end

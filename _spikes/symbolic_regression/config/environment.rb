Nudge::Config.setup do |experiment|
  
  # set up instructions
  experiment.instructions = Instruction.all_instructions
  
  # set up variable names
  experiment.variable_names = ["x1"]
  
  # set up types
  experiment.types = [IntType, BoolType, FloatType]
  
  # set up stations
end

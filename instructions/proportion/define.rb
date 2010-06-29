class ProportionDefine < NudgeInstruction
  get 1, :name
  get 1, :proportion
  
  def process
    key = name(0)
    bindings = @outcome_data.variable_bindings
    
    raise(NudgeError::VariableRedefined, "cannot redefine variable #{key}") if bindings.key?(key)
    
    bindings[key] = Value.new(:proportion, proportion(0))
  end
end

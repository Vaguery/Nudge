# encoding: UTF-8
class BoolDefine < NudgeInstruction
  get 1, :name
  get 1, :bool
  
  def process
    key = name(0)
    bindings = @outcome_data.variable_bindings
    
    raise(NudgeError::VariableRedefined, "cannot redefine variable #{key}") if bindings.key?(key)
    
    bindings[key] = Value.new(:bool, bool(0))
  end
end

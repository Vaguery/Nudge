# encoding: UTF-8
class ExecDefine < NudgeInstruction
  get 1, :name
  get 1, :exec
  
  def process
    key = name(0)
    bindings = @outcome_data.variable_bindings
    
    raise(NudgeError::VariableRedefined, "cannot redefine variable #{key}") if bindings.key?(key)
    
    bindings[key] = ValuePoint.new(:exec, exec(0))
  end
end

# encoding: UTF-8
class CodeNameLookup < NudgeInstruction
  get 1, :name
  
  def process
    unless @executable.variable_bindings.has_key?(name(0))
      raise NudgeError::UnboundName, "code_name_lookup referenced an unbound name"
    end
    
    put :code, @executable.variable_bindings[name(0)].to_script
  end
end

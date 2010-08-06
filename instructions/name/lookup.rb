# encoding: UTF-8
class NameLookup < NudgeInstruction
  get 1, :name
  
  def process
    unless @executable.variable_bindings.has_key?(name(0))
      raise NudgeError::UnboundName, "name_lookup referenced an unbound name"
    end
    
    @executable.variable_bindings[name(0)].evaluate(@executable)
  end
end

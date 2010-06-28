class BoolDefine < NudgeInstruction
  get 1, :name
  get 1, :bool
  
  def process
    key = name(0)
    bindings = @outcome_data.variable_bindings
    
    if bindings.key?(key)
      # raise
    end
    
    bindings[key] = Value.new(:bool, bool(0))
  end
end

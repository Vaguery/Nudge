class Instruction::IntDefine < Instruction
  get 1, :name
  get 1, :int
  
  def process
    key = name(0)
    bindings = @outcome_data.variable_bindings
    
    if bindings.key?(key)
      # raise
    end
    
    bindings[key] = Value.new(:int, int(0))
  end
end

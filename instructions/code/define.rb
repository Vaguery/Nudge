class Instruction::CodeDefine < Instruction
  get 1, :name
  get 1, :code
  
  def process
    key = name(0)
    bindings = @outcome_data.variable_bindings
    
    if bindings.key?(key)
      # raise
    end
    
    bindings[key] = Value.new(:code, code(0))
  end
end

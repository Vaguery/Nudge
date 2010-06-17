class Instruction::ProportionDefine < Instruction
  get 1, :name
  get 1, :proportion
  
  def process
    key = name(0)
    bindings = @outcome_data.variable_bindings
    
    if bindings.key?(key)
      # raise
    end
    
    bindings[key] = Value.new(:proportion, proportion(0))
  end
end

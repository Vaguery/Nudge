class Instruction::BoolSwap < Instruction
  get 2, :bool
  
  def process
    put :bool, bool(0)
    put :bool, bool(1)
  end
end

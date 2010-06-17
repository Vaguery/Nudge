class Instruction::BoolXor < Instruction
  get 2, :bool
  
  def process
    put :bool, bool(0) != bool(1)
  end
end

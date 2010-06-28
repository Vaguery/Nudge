class Instruction::BoolDuplicate < Instruction
  get 1, :bool
  
  def process
    put :bool, bool(0)
    put :bool, bool(0)
  end
end

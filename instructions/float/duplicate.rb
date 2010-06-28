class Instruction::FloatDuplicate < Instruction
  get 1, :float
  
  def process
    put :float, float(0)
    put :float, float(0)
  end
end

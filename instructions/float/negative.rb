class Instruction::FloatNegative < Instruction
  get 2, :float
  
  def process
    put :float, -float(0)
  end
end

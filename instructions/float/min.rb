class Instruction::FloatMin < Instruction
  get 2, :float
  
  def process
    put :float, [float(0), float(1)].min
  end
end

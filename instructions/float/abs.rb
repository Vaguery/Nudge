class Instruction::FloatAbs < Instruction
  get 1, :float
  
  def process
    put :float, float(0).abs
  end
end

class Instruction::FloatSqrt < Instruction
  get 1, :float
  
  def process
    if float(0) > 0
      put :float, Math.sqrt(float(0))
    else
      # raise
    end
  end
end

class Instruction::FloatDivide < Instruction
  get 2, :float
  
  def process
    if float(1) != 0
      put :float, float(0) / float(1)
    else
      # raise
    end
  end
end

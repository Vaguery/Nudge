class Instruction::IntPower < Instruction
  get 2, :int
  
  def process
    if int(0) == 0 && int(1) < 0
      # raise
    else
      put :int, int(0) ** int(1)
    end
  end
end

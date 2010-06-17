class Instruction::IntRotate < Instruction
  get 3, :int
  
  def process
    put :int, int(1)
    put :int, int(0)
    put :int, int(2)
  end
end

class Instruction::IntNegative < Instruction
  get 1, :int
  
  def process
    put :int, -int(0)
  end
end

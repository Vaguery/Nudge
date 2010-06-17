class Instruction::IntAbs < Instruction
  get 1, :int
  
  def process
    put :int, int(0).abs
  end
end

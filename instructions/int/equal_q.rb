class Instruction::IntEqualQ < Instruction
  get 2, :int
  
  def process
    put :bool, int(0) == int(1)
  end
end

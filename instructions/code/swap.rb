class Instruction::CodeSwap < Instruction
  get 2, :code
  
  def process
    put :code, code(0)
    put :code, code(1)
  end
end

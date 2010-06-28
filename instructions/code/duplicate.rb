class Instruction::CodeDuplicate < Instruction
  get 1, :code
  
  def process
    put :code, code(0)
    put :code, code(0)
  end
end

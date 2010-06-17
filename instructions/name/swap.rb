class Instruction::NameSwap < Instruction
  get 2, :name
  
  def process
    put :name, name(0)
    put :name, name(1)
  end
end

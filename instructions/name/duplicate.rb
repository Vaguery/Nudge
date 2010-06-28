class Instruction::NameDuplicate < Instruction
  get 1, :name
  
  def process
    put :name, name(0)
    put :name, name(0)
  end
end

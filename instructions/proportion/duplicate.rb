class Instruction::ProportionDuplicate < Instruction
  get 1, :proportion
  
  def process
    put :proportion, proportion(0)
    put :proportion, proportion(0)
  end
end

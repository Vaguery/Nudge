class Instruction::ProportionSwap < Instruction
  get 2, :proportion
  
  def process
    put :proportion, proportion(0)
    put :proportion, proportion(1)
  end
end

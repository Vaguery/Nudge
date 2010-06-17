class Instruction::ProportionMax < Instruction
  get 2, :proportion
  
  def process
    put :proportion, [proportion(0), proportion(1)].max
  end
end

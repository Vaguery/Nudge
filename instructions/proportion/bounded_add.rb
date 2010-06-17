class Instruction::ProportionBoundedAdd < Instruction
  get 2, :proportion
  
  def process
    put :proportion, [proportion(0) + proportion(1), 1.0].min
  end
end

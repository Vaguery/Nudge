class Instruction::ProportionIf < Instruction
  get 1, :bool
  get 2, :proportion
  
  def process
    put :proportion, bool(0) ? proportion(0) : proportion(1)
  end
end

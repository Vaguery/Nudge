class ProportionComplement < NudgeInstruction
  get 1, :proportion
  
  def process
    put :proportion, 1.0 - proportion(0)
  end
end

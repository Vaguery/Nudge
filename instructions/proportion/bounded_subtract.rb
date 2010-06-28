class ProportionBoundedSubtract < NudgeInstruction
  get 2, :proportion
  
  def process
    put :proportion, [proportion(0) - proportion(1), 0.0].max
  end
end

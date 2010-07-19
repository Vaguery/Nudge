class ProportionEqualQ < NudgeInstruction
  get 2, :proportion
  
  def process
    put :bool, proportion(0) == proportion(1)
  end
end

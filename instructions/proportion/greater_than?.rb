class ProportionGreaterThanQ < NudgeInstruction
  get 2, :proportion
  
  def process
    put :bool, proportion(1) > proportion(0)
  end
end

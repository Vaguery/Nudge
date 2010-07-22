class FloatFromProportion < NudgeInstruction
  get 1, :proportion
  
  def process
    put :float, proportion(0)
  end
end

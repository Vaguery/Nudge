class FloatAffineInterpolation < NudgeInstruction
  get 2, :float
  get 1, :proportion
  
  def process
    put :float, proportion(0)*float(0) + (1-proportion(0))*float(1)
  end
end

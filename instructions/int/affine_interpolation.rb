class IntAffineInterpolation < NudgeInstruction
  get 2, :int
  get 1, :proportion
  
  def process
    put :int, (proportion(0)*int(0) + (1-proportion(0))*int(1)).round
  end
end

class FloatAffineCombination < NudgeInstruction
  get 3, :float
  
  def process
    start_pt = float(1)
    end_pt = float(2)
    lambda = float(0)
    put :float, lambda*start_pt + (1.0-lambda)*end_pt
  end
end

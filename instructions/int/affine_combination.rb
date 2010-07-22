class IntAffineCombination < NudgeInstruction
  get 2, :int
  get 1, :float
  
  def process
    start_pt = int(0)
    end_pt = int(1)
    lambda = float(0)
    put :int, (lambda*start_pt + (1.0-lambda)*end_pt).round
  end
end

class IntFromFloat < NudgeInstruction
  get 1, :float
  
  def process
    put :int, float(0).round
  end
end

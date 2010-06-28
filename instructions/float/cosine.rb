class FloatCosine < NudgeInstruction
  get 1, :float
  
  def process
    put :float, Math.cos(float(0))
  end
end

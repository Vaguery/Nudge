class FloatSine < NudgeInstruction
  get 1, :float
  
  def process
    put :float, Math.sin(float(0))
  end
end

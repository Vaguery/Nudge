class FloatEqualQ < NudgeInstruction
  get 2, :float
  
  def process
    put :bool, float(0) == float(1)
  end
end

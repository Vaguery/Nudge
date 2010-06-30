class FloatGreaterThanQ < NudgeInstruction
  get 2, :float
  
  def process
    put :bool, float(1) > float(0)
  end
end

class FloatSwap < NudgeInstruction
  get 2, :float
  
  def process
    put :float, float(0)
    put :float, float(1)
  end
end

class FloatPower < NudgeInstruction
  get 2, :float
  
  def process
    result = float(0) ** float(1)
    
    if result.infinite? || result.nan?
      # raise
    else
      put :float, result
    end
  end
end

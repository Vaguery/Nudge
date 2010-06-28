class FloatRandom < NudgeInstruction
  get 1, :float
  
  def process
    min = Settings::FLOAT_MINIMUM.to_f
    max = Settings::FLOAT_MAXIMUM.to_f
    low, high = [min, max].sort
    
    put :float, rand * (high - low) + low
  end
end

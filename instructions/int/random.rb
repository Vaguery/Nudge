class Instruction::IntRandom < Instruction
  get 1, :int
  
  def process
    min = Settings::INT_MINIMUM
    max = Settings::INT_MAXIMUM
    low, high = [min, max].sort
    
    put :int, rand(high - low).to_i + low
  end
end

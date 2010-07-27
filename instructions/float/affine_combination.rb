# encoding: UTF-8
class FloatAffineCombination < NudgeInstruction
  get 3, :float
  
  def process
    λ = float(0)
    x = float(1)
    y = float(2)
    
    put :float, λ * x + (1.0 - λ) * y
  end
end

# encoding: UTF-8
class FloatAffineInterpolation < NudgeInstruction
  get 2, :float
  get 1, :proportion
  
  def process
    λ = proportion(0)
    x = float(0)
    y = float(1)
    
    put :float, λ * x + (1.0 - λ) * y
  end
end

# encoding: UTF-8
class IntAffineInterpolation < NudgeInstruction
  get 2, :int
  get 1, :proportion
  
  def process
    λ = proportion(0)
    x = int(0)
    y = int(1)
    
    put :int, (λ * x + (1.0 - λ) * y).round
  end
end

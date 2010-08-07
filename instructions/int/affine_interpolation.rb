# encoding: UTF-8
class IntAffineInterpolation < NudgeInstruction
  get 2, :int
  get 1, :proportion
  
  def process
    λ = proportion(0)
    x = int(0)
    y = int(1)
    
    result = λ * x + (1.0 - λ) * y
    
    raise NudgeError::NaN, "result of int_affine_interpolation was infinity" if result == (1.0/0)
    
    put :int, result.round
  end
end

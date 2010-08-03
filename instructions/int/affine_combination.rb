# encoding: UTF-8
class IntAffineCombination < NudgeInstruction
  get 2, :int
  get 1, :float
  
  def process
    λ = float(0)
    x = int(0)
    y = int(1)
    
    result = λ * x + (1.0 - λ) * y
    
    raise NudgeError::NaN, "result of int_affine_combination was infinity" if result.infinite?
    
    put :int, result.round
  end
end

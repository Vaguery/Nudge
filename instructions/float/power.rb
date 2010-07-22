# encoding: UTF-8
class FloatPower < NudgeInstruction
  get 2, :float
  
  def process
    result = float(1) ** float(0)
    
    if result.infinite? || result.nan?
      raise NudgeError::NaN, "result of float exponent was not a number"
    else
      put :float, result
    end
  end
end

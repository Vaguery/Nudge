# encoding: UTF-8
class FloatSqrt < NudgeInstruction
  get 1, :float
  
  def process
    if float(0) >= 0
      put :float, Math.sqrt(float(0))
    else
      raise NudgeError::NaN, "result of square root was not a float"
    end
  end
end

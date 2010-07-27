# encoding: UTF-8
class FloatSqrt < NudgeInstruction
  get 1, :float
  
  def process
    raise NudgeError::NaN, "result of square root was not a float" if float(0) < 0
    
    put :float, Math.sqrt(float(0))
  end
end

# encoding: UTF-8
class FloatPower < NudgeInstruction
  get 2, :float
  
  def process
    result = float(1) ** float(0)
    
    if result.is_a?(Complex) || result==(1.0/0)
      raise NudgeError::NaN, "result of float_power was not a float"
    else
      put :float, result
    end
    
  end
end

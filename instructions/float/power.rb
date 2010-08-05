# encoding: UTF-8
class FloatPower < NudgeInstruction
  get 2, :float
  
  def process
    result = float(1) ** float(0)
    
    # can somehow result in complex number
    
    if result.infinite? || result.nan? 
      raise NudgeError::NaN, "result of float_power was not a float"
    else
      put :float, result
    end
    
  rescue NoMethodError, ZeroDivisionError
  end
end

# encoding: UTF-8
class FloatUnlimitedPower < NudgeInstruction
  get 2, :float
  
  def process
    result = float(1) ** float(0)
    
    raise NudgeError::NaN,
      "result of float_unlimited_power was not a float" if result.is_a?(Complex) || result.infinite?
    
    put :float, result
    
  end
end

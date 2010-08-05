# encoding: UTF-8
class IntPower < NudgeInstruction
  get 2, :int
  
  def process
    base = int(1)
    exponent = int(0)
    
    raise NudgeError::DivisionByZero, "int_power" if base == 0 && exponent < 0
    
    result = base ** exponent
    
    raise NudgeError::NaN, "result of int_power was Infinity" if result.to_s == "Infinity"
    
    put :int, result.to_i
  rescue NoMethodError
  end
end

# encoding: UTF-8
class IntUnlimitedPower < NudgeInstruction
  get 2, :int
  
  def process
    base = int(1)
    exponent = int(0)
    
    raise NudgeError::DivisionByZero, "int_unlimited_power" if base == 0 && exponent < 0
    
    old_verbose = $VERBOSE
    $VERBOSE = nil
    
    result = base ** exponent
    
    $VERBOSE = old_verbose
    
    raise NudgeError::NaN, "result of int_power was Infinity" if result.to_s == "Infinity"
    
    put :int, result.to_i
  rescue NoMethodError
  end
end

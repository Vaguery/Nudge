# encoding: UTF-8
class IntPower < NudgeInstruction
  get 2, :int
  
  def process
    result = int(1) ** int(0)
    
    raise NudgeError::NaN, "result of int_power was not an integer" unless result.is_a? Integer
    
    put :int, result
  end
end

class IntPower < NudgeInstruction
  get 2, :int
  
  def process
    result = int(1) ** int(0)
    
    raise NudgeError::NaN, "result of int_power was Infinity" if result.to_s == "Infinity"
    
    put :int, result.to_i
  end
end

class IntPower < NudgeInstruction
  get 2, :int
  
  def process
    if int(1) == 0 && int(0) < 0
      raise NudgeError::NaN, "result of int power was not a number"
    else
      result = int(1) ** int(0)
      unless result.to_s == "Infinity"
        put :int, result.to_i
      else
        raise NudgeError::NaN, "result of int power was Infinity"
      end
    end
  end
end

class IntPower < NudgeInstruction
  get 2, :int
  
  def process
    if int(0) == 0 && int(1) < 0
      raise NudgeError::NaN, "result of int exponent was not a number"
    else
      put :int, int(0) ** int(1)
    end
  end
end

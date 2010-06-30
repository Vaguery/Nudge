class IntPower < NudgeInstruction
  get 2, :int
  
  def process
    if int(1) == 0 && int(0) < 0
      raise NudgeError::NaN, "result of int exponent was not a number"
    else
      put :int, int(1) ** int(0)
    end
  end
end

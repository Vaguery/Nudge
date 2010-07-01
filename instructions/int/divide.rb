class IntDivide < NudgeInstruction
  get 2, :int
  
  def process
    if int(0) != 0
      put :int, int(1) / int(0)
    else
      raise NudgeError::DivisionByZero, "cannot divide an int by 0"
    end
  end
end

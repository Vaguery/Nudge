class IntModulo < NudgeInstruction
  get 2, :int
  
  def process
    if int(0) != 0
      put :int, int(1) % int(0)
    else
      raise NudgeError::DivisionByZero, "cannot perform int modulo zero"
    end
  end
end

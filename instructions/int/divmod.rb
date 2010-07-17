class IntDivmod < NudgeInstruction
  get 2, :int
  
  def process
    if int(0) != 0
      r1,r2 = int(1).divmod(int(0))
      put :int, r1
      put :int, r2
    else
      raise NudgeError::DivisionByZero, "cannot perform int modulo zero"
    end
  end
end

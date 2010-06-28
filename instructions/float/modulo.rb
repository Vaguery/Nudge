class FloatModulo < NudgeInstruction
  get 2, :float
  
  def process
    if float(1) != 0
      put :float, float(0) % float(1)
    else
      raise NudgeError::DivisionByZero, "cannot perform float modulo zero"
    end
  end
end

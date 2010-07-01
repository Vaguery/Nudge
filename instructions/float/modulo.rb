class FloatModulo < NudgeInstruction
  get 2, :float
  
  def process
    if float(0) != 0
      put :float, float(1) % float(0)
    else
      raise NudgeError::DivisionByZero, "cannot perform float modulo zero"
    end
  end
end

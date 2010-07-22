class FloatDivmod < NudgeInstruction
  get 2, :float
  
  def process
    raise NudgeError::DivisionByZero, "cannot divide a float by 0.0" if float(0) == 0.0
    
    quotient, modulus = float(1).divmod float(0)
    put :float, quotient
    put :float, modulus
  end
end

# encoding: UTF-8
class FloatDivmod < NudgeInstruction
  get 2, :float
  
  def process
    raise NudgeError::DivisionByZero, "float_mod" if float(0) == 0.0
    
    quotient, modulus = float(1).divmod float(0)
    
    put :float, quotient
    put :float, modulus
    
  rescue FloatDomainError => err
    raise NudgeError::NaN, "float_mod result was infinite"
  end
end

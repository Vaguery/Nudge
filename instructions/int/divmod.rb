# encoding: UTF-8
class IntDivmod < NudgeInstruction
  get 2, :int
  
  def process
    raise NudgeError::DivisionByZero, "cannot divide an int by 0" if int(0) == 0
    
    quotient, modulus = int(1).divmod int(0)
    
    put :int, quotient
    put :int, modulus
  end
end

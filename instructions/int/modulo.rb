# encoding: UTF-8
class IntModulo < NudgeInstruction
  get 2, :int
  
  def process
    raise NudgeError::DivisionByZero, "cannot perform int modulo zero" if int(0) == 0
    
    put :int, int(1) % int(0)
  end
end

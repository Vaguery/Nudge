# encoding: UTF-8
class FloatModulo < NudgeInstruction
  get 2, :float
  
  def process
    raise NudgeError::DivisionByZero, "cannot perform float modulo zero" if float(0) == 0
    
    put :float, float(1) % float(0)
  end
end

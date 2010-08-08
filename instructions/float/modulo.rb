# encoding: UTF-8
class FloatModulo < NudgeInstruction
  get 2, :float
  
  def process
    raise NudgeError::DivisionByZero, "cannot perform float modulo zero" if float(0) == 0
    
    result = float(1) % float(0)
    raise NudgeError::NaN, "float_modulo result was not a float" if result.infinite?
    
    put :float, result
  end
end

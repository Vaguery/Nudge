# encoding: UTF-8
class FloatDivide < NudgeInstruction
  get 2, :float
  
  def process
    raise NudgeError::DivisionByZero, "cannot divide a float by 0.0" if float(0) == 0.0
    
    result = float(1) / float(0)
    raise NudgeError::NaN, "float_divide result was not a :float" if result.infinite?
    
    put :float, result
  end
end

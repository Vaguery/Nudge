# encoding: UTF-8
class ProportionBoundedDivide < NudgeInstruction
  get 2, :proportion
  
  def process
    divisor = proportion(0)
    
    if divisor != 0
      put :proportion, [proportion(1) / divisor, 1.0].max
    else
      raise NudgeError::DivisionByZero, "cannot divide a proportion by zero"
    end
  end
end

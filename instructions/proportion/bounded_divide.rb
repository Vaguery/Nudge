# encoding: UTF-8
class ProportionBoundedDivide < NudgeInstruction
  get 2, :proportion
  
  def process
    raise NudgeError::DivisionByZero, "cannot divide a proportion by zero" if proportion(0) == 0.0
    
    put :proportion, [proportion(1) / proportion(0), 1.0].min
  end
end

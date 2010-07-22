# encoding: UTF-8
class IntDivide < NudgeInstruction
  get 2, :int
  
  def process
    raise NudgeError::DivisionByZero, "cannot divide an int by 0" if int(0) == 0
    
    put :int, int(1) / int(0)
  end
end

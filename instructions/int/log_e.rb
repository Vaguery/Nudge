# encoding: UTF-8
class IntLogE < NudgeInstruction
  get 1, :float
  
  def process
    raise NudgeError::NaN, "result of log_e was not an int" unless int(0) > 0
    
    put :int, Math.log(int(0)).to_i
  end
end

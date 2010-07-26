# encoding: UTF-8
class IntLogE < NudgeInstruction
  get 1, :int
  
  def process
    if int(0) > 0
      put :int, Math.log(int(0)).to_i
    else
      raise NudgeError::NaN, "result of log_e was not an int"
    end
  end
end

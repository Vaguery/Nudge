# encoding: UTF-8
class IntLogE < NudgeInstruction
  get 1, :int
  
  def process
    unless int(0) > 0 && (result = Math.log(int(0))).finite?
      raise NudgeError::NaN, "result of int_log_e was not an int"
    end
    
    put :int, result.to_i
  end
end

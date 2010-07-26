# encoding: UTF-8
class FloatLogE < NudgeInstruction
  get 1, :float
  
  def process
    if float(0) >= 0
      put :float, Math.log(float(0))
    else
      raise NudgeError::NaN, "result of log_e was not a float"
    end
  end
end

# encoding: UTF-8
class ExecDoCount < NudgeInstruction
  get 1, :exec
  get 1, :int
  
  def process
    raise NudgeError::NegativeCounter, "exec_do_count called with negative counter" if int(0) < 0
    
    point = exec(0)
    
    case int(0)
    when 0
    when 1 then put :exec, point
    else
      i = Value.new(:int, int(0) - 1)
      do_count = DoPoint.new(:exec_do_count)
      
      put :exec, BlockPoint.new(i, do_count, point.dup)
      put :exec, point
    end
  end
end

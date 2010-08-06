# encoding: UTF-8
class CodeDoCount < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    raise NudgeError::NegativeCounter, "code_do_count called with negative counter" if int(0) < 0
    
    script = code(0)
    
    case int(0)
      when 0
      when 1 then put :exec, NudgePoint.from(script)
    else
      i = Value.new(:int, int(0) - 1)
      do_count = DoPoint.new(:exec_do_count)
      
      put :exec, BlockPoint.new(i, do_count, NudgePoint.from(script))
      put :exec, NudgePoint.from(script)
    end
  end
end

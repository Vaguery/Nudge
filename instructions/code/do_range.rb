# encoding: UTF-8
class CodeDoRange < NudgeInstruction
  get 1, :code
  get 2, :int
  
  def process
    put :int, i = int(1)
    limit = int(0)
    script = code(0)
    
    if i == limit
      put :exec, NudgePoint.from(script)
      return
    end
    
    i = Value.new(:int, i + (limit <=> i))
    limit = Value.new(:int, limit)
    do_range = DoPoint.new(:exec_do_range)
    
    put :exec, BlockPoint.new(i, limit, do_range, NudgePoint.from(script))
    put :exec, NudgePoint.from(script)
  end
end

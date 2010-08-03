# encoding: UTF-8
class CodeDoRange < NudgeInstruction
  get 1, :code
  get 2, :int
  
  def process
    put :int, i = int(1)
    limit = int(0)
    point = NudgePoint.from(code(0))
    
    if i == limit
      put :exec, point
      return
    end
    
    i = Value.new(:int, i + (limit <=> i))
    limit = Value.new(:int, limit)
    do_range = DoPoint.new(:exec_do_range)
    
    put :exec, BlockPoint.new(i, limit, do_range, point)
    put :exec, point
  end
end

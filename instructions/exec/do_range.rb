# encoding: UTF-8
class ExecDoRange < NudgeInstruction
  get 1, :exec
  get 2, :int
  
  def process
    put :int, i = int(1)
    limit = int(0)
    point = exec(0)
    
    if i == limit
      put :exec, point
      return
    end
    
    i = Value.new(:int, i + (limit <=> i))
    limit = Value.new(:int, limit)
    do_range = DoPoint.new(:exec_do_range)
    
    put :exec, BlockPoint.new(i, limit, do_range, point.dup)
    put :exec, point
  end
end

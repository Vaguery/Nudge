# encoding: UTF-8
class ExecDoTimes < NudgeInstruction
  get 1, :exec
  get 2, :int
  
  def process
    i = int(1)
    limit = int(0)
    point = exec(0)
    
    if i == limit
      put :exec, point
      return
    end
    
    i = Value.new(:int, i + (limit <=> i))
    limit = Value.new(:int, limit)
    do_times = DoPoint.new(:exec_do_times)
    
    put :exec, BlockPoint.new(i, limit, do_times, point)
    put :exec, point
  end
end

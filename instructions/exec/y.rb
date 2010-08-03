# encoding: UTF-8
class ExecY < NudgeInstruction
  get 1, :exec
  
  def process
    point = exec(0)
    y = DoPoint.new(:exec_y)
    
    put :exec, BlockPoint.new(y, point)
    put :exec, point
  end
end

# encoding: UTF-8
class ExecS < NudgeInstruction
  get 3, :exec
  
  def process
    a = exec(0)
    b = exec(1)
    c = exec(2)
    
    put :exec, BlockPoint.new(b, c)
    put :exec, c
    put :exec, a
  end
end

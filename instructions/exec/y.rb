# encoding: UTF-8
class ExecY < NudgeInstruction
  get 1, :exec
  
  def process
    a = exec(0)
    exec_y = DoPoint.new(:exec_y)
    block = BlockPoint.new(exec_y, a)
    
    put :exec, block
    put :exec, a
  end
end

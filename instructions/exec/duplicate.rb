# encoding: UTF-8
class ExecDuplicate < NudgeInstruction
  get 1, :exec
  
  def process
    put :exec, exec(0)
    put :exec, exec(0)
  end
end

# encoding: UTF-8
class ExecK < NudgeInstruction
  get 2, :exec
  
  def process
    put :exec, exec(0)
  end
end

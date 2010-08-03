# encoding: UTF-8
class CodeExecute < NudgeInstruction
  get 1, :code
  
  def process
    put :exec, NudgePoint.from(code(0))
  end
end

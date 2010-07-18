class CodeExecute < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    put :exec, tree
  end
end

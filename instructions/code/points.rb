class CodePoints < NudgeInstruction
  get 1, :code
  
  def process
    put :int, NudgePoint.from(code(0)).points
  end
end

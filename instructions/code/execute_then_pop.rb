class CodeExecuteThenPop < NudgeInstruction
  get 1, :code
  
  def process
    tree = BlockPoint.new(
      NudgePoint.from(code(0)),
      NudgePoint.from("do code_pop"))
    put :exec, tree
    put :code, code(0)
  end
end

class CodeCdr < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    tree.delete_point_at(1) if tree.is_a?(BlockPoint) && (tree.points > 1)
    put :code, tree.to_script
  end
end

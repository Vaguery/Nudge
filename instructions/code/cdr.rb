class CodeCdr < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    unless tree.kind_of?(NilPoint)
      result = if tree.is_a?(BlockPoint) && (tree.points > 1)
        tree.delete_point_at(1)
        tree.to_script
      else
        "block {}"
      end
      put :code, result
    else
      put :error, "code_cdr cannot parse an argument"
    end
  end
end

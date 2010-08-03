# encoding: UTF-8
class CodeCdr < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    
    raise NudgeError::InvalidScript, "code_cdr cannot parse an argument" if tree.is_a?(NilPoint)
    
    if tree.points > 1
      tree.delete_point_at(1)
      put :code, tree.to_script
    else
      put :code, "block { }"
    end
  end
end

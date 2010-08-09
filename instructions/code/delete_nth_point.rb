# encoding: UTF-8
class CodeDeleteNthPoint < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    tree = NudgePoint.from(code(0))
    
    if tree.is_a?(NilPoint)
      raise NudgeError::InvalidScript, "code_delete_nth_point can't parse an argument"
    end
    
    where = int(0) % tree.points
    
    if where > 0
      tree.delete_point_at(where)
      put :code, tree.to_script
    end
  end
end

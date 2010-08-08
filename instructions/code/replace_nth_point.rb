# encoding: UTF-8
class CodeReplaceNthPoint < NudgeInstruction
  get 2, :code
  get 1, :int
  
  def process
    arg1 = NudgePoint.from(code(1))
    arg2 = NudgePoint.from(code(0))
    
    if arg1.is_a?(NilPoint) || arg2.is_a?(NilPoint)
      raise NudgeError::InvalidScript, "code_replace_nth_point can't parse an argument"
    end
    
    where = int(0) % arg1.points
    
    if where == 0
      new_tree = arg2
    else
      arg1.replace_point_at(where, arg2)
      new_tree = arg1
    end
    
    put :code, new_tree.to_script
  end
end

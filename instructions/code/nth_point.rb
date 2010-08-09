# encoding: UTF-8
class CodeNthPoint < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    tree = NudgePoint.from(code(0))
    raise NudgeError::InvalidScript,"code_nth_point can't parse an argument" if tree.is_a?(NilPoint)
    
    where = int(0) % tree.points
    
    result = tree.get_point_at(where)
    
    put :code, result.to_script
  end
end

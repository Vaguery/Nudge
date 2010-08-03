# encoding: UTF-8
class CodeCar < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    
    raise NudgeError::InvalidScript, "code_car cannot parse an argument" if tree.is_a?(NilPoint)
    
    put :code, (tree.points > 1) ? tree.get_point_at(1).to_script : code(0)
  end
end

# encoding: UTF-8
class CodeLeaves < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    
    raise NudgeError::InvalidScript, "code_leaves cannot parse the argument" if tree.is_a?(NilPoint)
    
    put_atoms(tree)
  end
  
  
  def put_atoms(point)
    if point.is_a?(BlockPoint)
      backbone = point.instance_variable_get(:@points)
      backbone.each {|pt| put_atoms(pt)}
    else
      put :code, point.to_script
    end
  end
end

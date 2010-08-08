# encoding: UTF-8
class CodeNthBackbonePoint < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    tree = NudgePoint.from(code(0))
    which = int(0)
    
    raise NudgeError::InvalidScript,"code_nth_backbone_point can't parse :code" if tree.is_a?(NilPoint)
    
    if tree.is_a?(BlockPoint)
      raise NudgeError::InvalidIndex,"code_nth_backbone_point can't use empty block" unless tree.backbone_points > 0
      which %= tree.backbone_points
      result = tree.instance_variable_get(:@points)[which]
    else
      result = tree
    end
    
    put :code, result.to_script
  end
end

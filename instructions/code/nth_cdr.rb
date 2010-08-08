# encoding: UTF-8
class CodeNthCdr < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    tree = NudgePoint.from(code(0))
    raise NudgeError::InvalidScript,"code_nth_cdr cannot parse its argument" if tree.is_a?(NilPoint)
    
    tree = BlockPoint.new(tree) unless tree.is_a?(BlockPoint)
    
    if tree.points > 1
      n = [tree.backbone_points, [int(0), 0].max].min
      n.times { tree.delete_point_at(1) }
    end
    
    put :code, tree.to_script
  end
end

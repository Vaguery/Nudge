# encoding: UTF-8
class CodeNthCdr < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    tree = NudgePoint.from(code(0))
    tree = BlockPoint.new(tree) unless tree.is_a?(BlockPoint)
    n = [tree.points - 1, [int(0), 0].max].min
    
    n.times { tree.delete_point_at(1) }
    put :code, tree.to_script
  end
end

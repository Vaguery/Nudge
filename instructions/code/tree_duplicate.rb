# encoding: UTF-8
class CodeTreeDuplicate < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    
    case 
    when tree.is_a?(NilPoint)
      raise NudgeError::InvalidScript, "code_tree_duplicate"
    when tree.is_a?(BlockPoint)
      tree.insert_point_before(1,tree.get_point_at(1)) if tree.points > 1
    else
      tree = BlockPoint.new(tree, tree)
    end
    
    put :code, tree.to_script
  end
end

# encoding: UTF-8
class CodeTreeMaxdepth < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    
    raise NudgeError::InvalidScript, "code_tree_maxdepth" if tree.is_a?(NilPoint)
    
    put :int, max_treedepth(tree)
  end
  
  def max_treedepth(tree, max=1)
    if tree.is_a?(BlockPoint)
      depths = tree.instance_variable_get(:@points).collect {|pt| max_treedepth(pt, max+1)} << max
      depths.max
    else
      max
    end
  end
end

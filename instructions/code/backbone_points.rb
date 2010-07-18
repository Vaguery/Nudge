class CodeBackbonePoints < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    pts = if tree.is_a?(BlockPoint)
      tree.instance_variable_get(:@points).length
      else
        0
      end
    
    put :int, pts
  end
end

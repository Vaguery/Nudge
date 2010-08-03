# encoding: UTF-8
class CodeBackbonePoints < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    
    put :int, (tree.instance_variable_get(:@points).length rescue 0)
  end
end

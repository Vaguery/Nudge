# encoding: UTF-8
class CodeReverse < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    
    if points = tree.instance_variable_get(:@points)
      put :code, BlockPoint.new(*points.reverse).to_script
    else
      put :code, code(0)
    end
  end
end

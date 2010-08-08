# encoding: UTF-8
class CodeFlatten < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    tree = NudgePoint.from(code(0))
    depth = int(0)
    
    raise NudgeError::InvalidScript, "code_flatten can't parse its argument" if tree.is_a?(NilPoint)
    
    if tree.is_a?(BlockPoint) && depth > 0
      get_points(tree, depth, collected_points = [])
      result = BlockPoint.new(*collected_points).to_script
    else
      result = code(0)
    end
    
    put :code, result
  end
  
  
  def get_points (point, depth, collected_points)
    if depth >= 0 && points = point.instance_variable_get(:@points)
      points.each {|p| get_points(p, depth - 1, collected_points) }
    else
      collected_points << point
    end
  end
end

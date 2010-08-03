# encoding: UTF-8
class CodeShatter < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    get_points(NudgePoint.from(code(0)), int(0), collected_points = [])
    
    collected_points.each do |point|
      put :code, point.to_script
    end
  end
  
  def get_points (point, depth, collected_points)
    if depth > 0 && points = point.instance_variable_get(:@points)
      points.each {|p| get_points(p, depth - 1, collected_points) }
    else
      collected_points << point
    end
  end
end

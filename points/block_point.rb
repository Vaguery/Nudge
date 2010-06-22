class BlockPoint < NudgePoint
  def initialize (*points)
    @points = points
  end
  
  def evaluate (outcome_data)
    super
    outcome_data.stacks[:exec].concat(@points.reverse)
  end
  
  def points
    @points.inject(1) {|n,point| n + point.points }
  end
  
  def script_and_values
    values = []
    
    block_scripts = @points.collect do |point|
      point_script, point_values = point.script_and_values
      values.concat(point_values)
      point_script
    end
    
    return ["block {", block_scripts, "}"], values
  end
  
  def do_action_at_n (*args)
    point = catch(:complete) { do_action_at_n_recursively(*args) }
    point.is_a?(NudgePoint) ? point : false
  end
  
  def do_action_at_n_recursively (n, action, new_point)
    @points.each_with_index do |point, i|
      if (n -= 1) == 0
        old_point = @points[i]
        
        case action
          when :get
          when :delete         then @points.delete_at(i)
          when :replace        then @points[i..i] = new_point
          when :insert_before  then @points[i...i] = new_point
          when :insert_after   then @points[(i + 1)...(i + 1)] = new_point
        end
        
        throw(:complete, old_point)
      end
      
      n = point.do_action_at_n_recursively(n, action, new_point) if point.is_a? BlockPoint
    end
    
    return n
  end
end

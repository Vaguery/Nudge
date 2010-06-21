class NudgePoint
  ::NudgeIndexError = Class.new(ArgumentError)
  
  def NudgePoint.from (script)
    NudgeParser.new(script).send(:do_parse)
  end
  
  # called as `super` from points' individual #evaluate methods
  def evaluate (outcome_data)
    raise "over point limit" if (outcome_data.points_evaluated += 1) > Outcome::POINT_LIMIT
    raise "over time limit" if Time.now.to_i > outcome_data.expiration_moment
  end
  
  def points
    1
  end
  
  def get_point_at (n)
    return self if n == 1
    at(n, :get)
  end
  
  def delete_point_at (n)
    at(n, :replace)
  end
  
  def replace_point_at (n, new_point)
    at(n, :replace, new_point)
  end
  
  def insert_point_before (n, new_point)
    at(n, :insert_before, new_point)
  end
  
  def insert_point_after (n, new_point)
    at(n, :insert_after, new_point)
  end
  
  def at (n, action, new_point = nil)
    raise NudgeIndexError, "can't #{action} outermost point" if n == 1
    
    do_action_at_n(n, action, new_point) ||
      raise(NudgeIndexError, "point index out of range (#{n} from #{points})")
  end
  
  def do_action_at_n (*)
    false
  end
end

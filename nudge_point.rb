# encoding: UTF-8
class NudgePoint
  def NudgePoint.from (script)
    NudgeParser.new(script).send(:do_parse)
  rescue NudgeError
    NilPoint.new(script)
  end
  
  def to_script
    script, values = script_and_values
    [script].join(" ") + "\n" + values.join("\n")
  end
  
  def evaluate (outcome_data)
    if Time.now.to_f > outcome_data.start_moment + Outcome::TIME_LIMIT
      n = outcome_data.points_evaluated
      raise NudgeError::TimeLimitExceeded, "the time limit was exceeded after evaluating #{n} points"
    end
    
    if (outcome_data.points_evaluated += 1) > Outcome::POINT_LIMIT
      t = (Time.now - outcome_data.start_moment).to_i
      raise NudgeError::TooManyPointsEvaluated, "the point evaluation limit was exceeded after #{t} seconds"
    end
  end
  
  def points
    1
  end
  
  def get_point_at (n)
    return self if n == 0
    at(n, :get)
  end
  
  def delete_point_at (n)
    at(n, :delete)
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
    raise NudgeError::OutermostPointOperation, "can't #{action} outermost point" if n == 0
    
    do_action_at_n(n, action, new_point) ||
      raise(NudgeError::PointIndexTooLarge, "can't operate on point #{n} in a tree of size #{points}")
  end
  
  def do_action_at_n (*)
    false
  end
end

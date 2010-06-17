class NudgePoint
  def NudgePoint.from (script)
    NudgeParser.new(script).send(:do_parse)
  end
  
  # called as `super` from points' individual #evaluate methods
  def evaluate (outcome_data)
    raise "over point limit" if (outcome_data.points_evaluated += 1) > Outcome::POINT_LIMIT
    raise "over time limit" if Time.now.to_i > outcome_data.expiration_moment
  end
end

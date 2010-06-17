class BlockPoint < NudgePoint
  def initialize (*points)
    @points = points
  end
  
  def evaluate (outcome_data)
    super
    outcome_data.stacks[:exec].concat(@points.reverse)
  end
end

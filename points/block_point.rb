class BlockPoint < NudgePoint
  def initialize (*points)
    @points = points
  end
  
  def evaluate (outcome_data)
    super
    outcome_data.stacks[:exec].concat(@points.reverse)
  end
  
  def get_point (n)
    return self if n == 1
    
    @points.inject(n) do |n, point|
      n = point.get_point(n - 1)
      break n if n.is_a?(NudgePoint); n
    end
  end
end

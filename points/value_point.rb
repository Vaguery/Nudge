class ValuePoint < NudgePoint
  def initialize (type_id, string)
    @type_id = type_id
    @string = string
  end
  
  def evaluate (outcome_data)
    super
    outcome_data.stacks[@type_id].push(@string)
  end
end

class Value < ValuePoint
  def initialize (type_id, value)
    @type_id = type_id
    @string = value.to_s
  end
end

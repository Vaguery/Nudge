class NilPoint < NudgePoint
  def initialize (source_code)
    @source_code = source_code
  end
  
  def points
    0
  end
  
  def evaluate (outcome_data)
    super
  end
  
  def script_and_values
    return @source_code, []
  end
end

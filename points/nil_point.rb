# encoding: UTF-8
class NilPoint < NudgePoint
  def initialize (script)
    @script = script
  end
  
  def evaluate (outcome_data)
    super
  end
  
  def points
    0
  end
  
  def script_and_values
    return @script, []
  end
end

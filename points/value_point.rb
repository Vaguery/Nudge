# encoding: UTF-8
class ValuePoint < NudgePoint
  def initialize (value_type, string)
    @value_type = value_type
    @string = string
  end
  
  def evaluate (outcome_data)
    super
    @string.strip.length > 0 ? 
      outcome_data.stacks[@value_type].push(@string) : 
      outcome_data.stacks[:error].push("«#{@value_type}» has no value")
  end
  
  def script_and_values
    return "value «#{@value_type}»", ["«#{@value_type}»#{@string}"]
  end
end

class Value < ValuePoint
  def initialize (value_type, value)
    @value_type = value_type
    @string = value.to_s
  end
end

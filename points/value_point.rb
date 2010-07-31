# encoding: UTF-8
class ValuePoint < NudgePoint
  def initialize (value_type, string)
    @value_type = value_type
    @string = string
  end
  
  def evaluate (outcome_data)
    super
    
    if @string.is_a?(String) && @string.strip.empty?
      raise NudgeError::EmptyValue, "«#{@value_type}» has no value"
    end
    
    outcome_data.stacks[@value_type].push(@string)
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

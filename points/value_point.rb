# encoding: UTF-8
class ValuePoint < NudgePoint
  def initialize (value_type, value)
    @value_type = value_type
    @value = value
  end
  
  def evaluate (executable)
    if @value.is_a?(String) && @value.strip.empty?
      raise NudgeError::EmptyValue, "«#{@value_type}» has no value"
    end
    
    executable.stacks[@value_type] << @value
  end
  
  def script_and_values
    return "value «#{@value_type}»", ["«#{@value_type}»#{@value}"]
  end
end

class Value < ValuePoint
  def initialize (value_type, value)
    @value_type = value_type
    @value = value.to_s
  end
end

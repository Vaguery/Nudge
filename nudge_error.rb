# encoding: UTF-8
class NudgeError < StandardError
  %w[ DivisionByZero
      InvalidScript
      NaN
      OutermostPointOperation
      PointIndexTooLarge
      VariableRedefined
      TimeLimitExceeded
      TooManyPointsEvaluated
      MissingArguments
      UnknownInstruction ].each {|e| const_set(e, Class.new(self)) }
  
  def string
    "#{self.class.name.gsub(/.*::/,'')}: #{message}"
  end
end

# encoding: UTF-8
class NudgeError < StandardError
  %w[ DivisionByZero
      EmptyValue
      InvalidScript
      MissingArguments
      NaN
      OutermostPointOperation
      PointIndexTooLarge
      TimeLimitExceeded
      TooManyPointsEvaluated
      UnknownInstruction ].each {|e| const_set(e, Class.new(self)) }
  
  def string
    "#{self.class.name.gsub(/.*::/,'')}: #{message}"
  end
end

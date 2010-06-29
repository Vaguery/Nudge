class NudgeError < StandardError
  %w[ DivisionByZero
      InvalidScript
      NaN
      OutermostPointOperation
      PointIndexTooLarge
      VariableRedefined
      TimeLimitExceeded
      TooManyPointsEvaluated ].each {|e| const_set(e, Class.new(self)) }
  
  def string
    "#{self.class.name.gsub(/.*::/,'')}: #{message}"
  end
end

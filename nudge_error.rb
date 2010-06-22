class NudgeError < StandardError
  %w[ TimeLimitExceeded
      TooManyPointsEvaluated
      PointIndexTooLarge
      OutermostPointOperation
      InvalidScript ].each {|e| const_set(e, Class.new(self)) }
end

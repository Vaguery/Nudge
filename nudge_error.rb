class NudgeError < StandardError
  TimeLimitExceeded = Class.new(self)
  TooManyPointsEvaluated = Class.new(self)
  PointIndexTooLarge = Class.new(self)
  OutermostPointOperation = Class.new(self)
end

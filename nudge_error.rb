# encoding: UTF-8
class NudgeError < StandardError
  %w[ DivisionByZero
      EmptyValue
      InvalidIndex
      InvalidScript
      MissingArguments
      NaN
      NegativeCounter
      NotFound
      OutermostPointOperation
      PointIndexTooLarge
      TimeLimitExceeded
      TooManyPointsEvaluated
      UnboundName
      UnknownInstruction ].each {|e| const_set(e, Class.new(self)) }
end

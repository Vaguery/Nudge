# encoding: UTF-8
require File.expand_path("../nudge", File.dirname(__FILE__))

%w[ DivisionByZero
   EmptyValue
   InvalidScript
   MissingArguments
   NaN
   NegativeCounter
   OutermostPointOperation
   PointIndexTooLarge
   TimeLimitExceeded
   TooManyPointsEvaluated
   UnboundName
   UnknownInstruction ].each do |error_name|
  
  describe "NudgeError::#{error_name}" do
    it "is a subclass of NudgeError" do
      NudgeError.const_get(error_name).superclass.should == NudgeError
    end
  end
end

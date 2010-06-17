require 'nudge'

describe "NudgePoint" do
  describe ".from(script)" do
    it "returns a new NudgePoint" do
      NudgePoint.from("ref x1\n«int» 5").kind_of?(NudgePoint).should === true
    end
  end
  
  describe "#evaluate(outcome_data)" do
    it "increments by one the points evaluated by the outcome_data" do
      outcome_data = Outcome.new({})
      NudgePoint.new.evaluate(outcome_data)
      outcome_data.instance_variable_get(:@points_evaluated).should === 1
    end
    
    it "halts execution if points_evaluated exceeds POINT_LIMIT" do
      outcome_data = Outcome.new({})
      outcome_data.points_evaluated = Outcome::POINT_LIMIT
      lambda { NudgePoint.new.evaluate(outcome_data) }.should raise_error
    end
    
    it "halts execution if time is beyond TIME_LIMIT" do
      outcome_data = Outcome.new({})
      outcome_data.instance_variable_set(:@expiration_moment, Time.now.to_f - 10)
      lambda { NudgePoint.new.evaluate(outcome_data) }.should raise_error
    end
  end
end

#encoding:utf-8
require './nudge'

describe "NudgePoint" do
  describe ".from (script: String)" do
    it "returns a new NudgePoint" do
      NudgePoint.from("ref x1\n«int» 5").kind_of?(NudgePoint).should === true
    end
  end
  
  describe "#to_script" do
    it "returns a string representation of the Nudge program described by this point" do
      script = NudgePoint.from("block { ref x value «code» do int_add }\n«int»1\n«code»value «int»\n«int»2").to_script
      NudgePoint.from(script).to_script.should == script
    end
  end
  
  describe "#evaluate (outcome_data: Outcome)" do
    it "increments by one the points evaluated by the outcome_data" do
      outcome_data = Outcome.new({})
      NudgePoint.new.evaluate(outcome_data)
      outcome_data.instance_variable_get(:@points_evaluated).should === 1
    end
    
    it "halts execution if points_evaluated exceeds POINT_LIMIT" do
      pending
      outcome_data = Outcome.new({})
      outcome_data.instance_variable_set(:@points_evaluated, Outcome::POINT_LIMIT)
      outcome_data.instance_variable_set(:@expiration_moment, Time.now.to_f + 45)
      lambda { NudgePoint.new.evaluate(outcome_data) }.should raise_error NudgeError::TooManyPointsEvaluated,
        "the point evaluation limit was exceeded after 15 seconds"
    end
    
    it "halts execution if time is beyond TIME_LIMIT" do
      pending
      outcome_data = Outcome.new({})
      outcome_data.instance_variable_set(:@expiration_moment, Time.now.to_f - 10)
      outcome_data.instance_variable_set(:@points_evaluated, 20)
      lambda { NudgePoint.new.evaluate(outcome_data) }.should raise_error NudgeError::TimeLimitExceeded,
        "the time limit was exceeded after evaluating 20 points"
    end
  end
  
  describe "#points" do
    it "returns 1" do
      point = NudgePoint.new
      point.points.should == 1
    end
  end
  
  describe "#get_point_at (n: Fixnum)" do
    it "returns this point if n == 0" do
      point = NudgePoint.new
      point.get_point_at(0).should == point
    end
    
    it "raises PointIndexTooLarge if n != 0" do
      point = NudgePoint.new
      lambda { point.get_point_at(1) }.should raise_error NudgeError::PointIndexTooLarge,
        "can't operate on point 1 in a tree of size 1"
    end
  end
  
  describe "#delete_point_at (n: Fixnum)" do
    it "raises OutermostPointOperation" do
      point = NudgePoint.new
      lambda { point.delete_point_at(0) }.should raise_error NudgeError::OutermostPointOperation,
        "can't delete outermost point"
    end
  end
  
  describe "#replace_point_at (n: Fixnum, new_point: NudgePoint)" do
    it "raises OutermostPointOperation" do
      point = NudgePoint.new
      lambda { point.replace_point_at(0, point) }.should raise_error NudgeError::OutermostPointOperation,
        "can't replace outermost point"
    end
  end
  
  describe "#insert_point_before (n: Fixnum, new_point: NudgePoint)" do
    it "raises OutermostPointOperation" do
      point = NudgePoint.new
      lambda { point.insert_point_before(0, point) }.should raise_error NudgeError::OutermostPointOperation,
        "can't insert_before outermost point"
    end
  end
  
  describe "#insert_point_after (n: Fixnum, new_point: NudgePoint)" do
    it "raises OutermostPointOperation" do
      point = NudgePoint.new
      lambda { point.insert_point_after(0, point) }.should raise_error NudgeError::OutermostPointOperation,
        "can't insert_after outermost point"
    end
  end
end

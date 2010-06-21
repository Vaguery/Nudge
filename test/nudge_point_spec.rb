require 'nudge'

describe "NudgePoint" do
  describe ".from (script: String)" do
    it "returns a new NudgePoint" do
      NudgePoint.from("ref x1\n«int» 5").kind_of?(NudgePoint).should === true
    end
  end
  
  describe "#evaluate (outcome_data: Outcome)" do
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
  
  describe "#points" do
    it "returns 1" do
      point = NudgePoint.new
      point.points.should == 1
    end
  end
  
  describe "#get_point_at (n: Fixnum)" do
    it "returns this point if n == 1" do
      point = NudgePoint.new
      point.get_point_at(1).should == point
    end
    
    it "raises NudgeIndexError if n != 1" do
      point = NudgePoint.new
      lambda { point.get_point_at(2) }.should raise_error NudgeIndexError, "point index out of range (2 from 1)"
    end
  end
  
  describe "#delete_point_at (n: Fixnum)" do
    it "raises NudgeIndexError" do
      point = NudgePoint.new
      lambda { point.delete_point_at(1) }.should raise_error NudgeIndexError
    end
  end
  
  describe "#replace_point_at (n: Fixnum, new_point: NudgePoint)" do
    it "raises NudgeIndexError" do
      point = NudgePoint.new
      lambda { point.replace_point_at(1, point) }.should raise_error NudgeIndexError
    end
  end
  
  describe "#insert_point_before (n: Fixnum, new_point: NudgePoint)" do
    it "raises NudgeIndexError" do
      point = NudgePoint.new
      lambda { point.insert_point_before(1, point) }.should raise_error NudgeIndexError
    end
  end
  
  describe "#insert_point_after (n: Fixnum, new_point: NudgePoint)" do
    it "raises NudgeIndexError" do
      point = NudgePoint.new
      lambda { point.insert_point_after(1, point) }.should raise_error NudgeIndexError
    end
  end
end

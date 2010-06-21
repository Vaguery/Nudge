require 'nudge'

describe "BlockPoint" do
  describe ".new (*points: [NudgePoint, *])" do
    it "returns a new BlockPoint containing an array of the given points" do
      point_1 = BlockPoint.new
      point_2 = BlockPoint.new
      
      BlockPoint.new(point_1, point_2).instance_variable_get(:@points) == [point_1, point_2]
    end
  end
  
  describe "#evaluate (outcome_data: Outcome)" do
    it "pushes its points onto the exec stack in reverse order" do
      outcome_data = Outcome.new({})
      
      point_1 = BlockPoint.new
      point_2 = BlockPoint.new
      point_3 = BlockPoint.new
      
      BlockPoint.new(point_1, point_2, point_3).evaluate(outcome_data)
      
      outcome_data.stacks[:exec][2].should === point_1
      outcome_data.stacks[:exec][1].should === point_2
      outcome_data.stacks[:exec][0].should === point_3
    end
  end
  
  describe "#points" do
    it "returns the total number of points in the tree that has this point as its root" do
      point_2 = NudgePoint.new
      point_4 = NudgePoint.new
      point_5 = NudgePoint.new
      point_3 = BlockPoint.new(point_4, point_5)
      BlockPoint.new(point_2, point_3).points.should == 5
    end
  end
  
  describe "#get_point_at (n: Fixnum)" do
    it "returns this point if n == 1" do
      point = BlockPoint.new
      point.get_point_at(1).should == point
    end
    
    it "if n is less than self.points, returns the point corresponding to n" do
      point_2 = NudgePoint.new
      point_3 = NudgePoint.new
      BlockPoint.new(point_2, point_3).get_point_at(3).should == point_3
    end
    
    it "if n is greater than self.points, raises NudgeIndexError" do
      point_2 = NudgePoint.new
      point_3 = NudgePoint.new
      lambda { BlockPoint.new(point_2, point_3).get_point_at(5) }.should raise_error NudgeIndexError, "point index out of range (5 from 3)"
    end
  end
  
  describe "#delete_point_at (n: Fixnum)" do
    it "raises NudgeIndexError if n == 1" do
      point = BlockPoint.new
      lambda { point.replace_point_at(1, point) }.should raise_error NudgeIndexError, "can't replace outermost point"
    end
    
    it "if n is less than self.points, removes the point corresponding to n from the tree and returns that point" do
      point_2 = NudgePoint.new
      point_3 = NudgePoint.new
      point_1 = BlockPoint.new(point_2, point_3)
      
      point_1.delete_point_at(3).should == point_3
      lambda { point_1.get_point_at(3) }.should raise_error NudgeIndexError, "point index out of range (3 from 2)"
    end
    
    it "if n is greater than self.points, raises NudgeIndexError" do
      point_2 = NudgePoint.new
      point_3 = NudgePoint.new
      lambda { BlockPoint.new(point_2, point_3).delete_point_at(5) }.should raise_error NudgeIndexError, "point index out of range (5 from 3)"
    end
  end
  
  describe "#replace_point_at (n: Fixnum, new_point: NudgePoint)" do
    it "raises NudgeIndexError if n == 1" do
      point = BlockPoint.new
      lambda { point.replace_point_at(1, point) }.should raise_error NudgeIndexError, "can't replace outermost point"
    end
    
    it "if n is less than self.points, replaces the point corresponding to n with new_point and returns the replaced point" do
      point_r = NudgePoint.new
      point_2 = NudgePoint.new
      point_3 = NudgePoint.new
      point_1 = BlockPoint.new(point_2, point_3)
      
      point_1.replace_point_at(3, point_r).should == point_3
      point_1.points.should == 3
      point_1.get_point_at(3).should == point_r
    end
    
    it "if n is greater than self.points, raises NudgeIndexError" do
      point_2 = NudgePoint.new
      point_3 = NudgePoint.new
      lambda { BlockPoint.new(point_2, point_3).replace_point_at(5, point_2) }.should raise_error NudgeIndexError, "point index out of range (5 from 3)"
    end
  end
  
  describe "#insert_point_before (n: Fixnum, new_point: NudgePoint)" do
    it "raises NudgeIndexError if n == 1" do
      point = BlockPoint.new
      lambda { point.insert_point_before(1, point) }.should raise_error NudgeIndexError, "can't insert_before outermost point"
    end
    
    it "if n is less than self.points, inserts new_point before the point corresponding to n and returns the old nth point" do
      point_i = NudgePoint.new
      point_2 = NudgePoint.new
      point_3 = NudgePoint.new
      point_1 = BlockPoint.new(point_2, point_3)
      
      point_1.insert_point_before(3, point_i).should == point_3
      point_1.points.should == 4
      point_1.get_point_at(3).should == point_i
      point_1.get_point_at(4).should == point_3
    end
    
    it "if n is greater than self.points, raises NudgeIndexError" do
      point_2 = NudgePoint.new
      point_3 = NudgePoint.new
      lambda { BlockPoint.new(point_2, point_3).insert_point_before(5, point_2) }.should raise_error NudgeIndexError, "point index out of range (5 from 3)"
    end
  end
  
  describe "#insert_point_after (n: Fixnum, new_point: NudgePoint)" do
    it "raises NudgeIndexError if n == 1" do
      point = BlockPoint.new
      lambda { point.insert_point_after(1, point) }.should raise_error NudgeIndexError, "can't insert_after outermost point"
    end
    
    it "if n is less than self.points, inserts new_point after the point corresponding to n and returns the point at n" do
      point_i = NudgePoint.new
      point_2 = NudgePoint.new
      point_3 = NudgePoint.new
      point_1 = BlockPoint.new(point_2, point_3)
      
      point_1.insert_point_after(3, point_i).should == point_3
      point_1.points.should == 4
      point_1.get_point_at(3).should == point_3
      point_1.get_point_at(4).should == point_i
    end
    
    it "if n is greater than self.points, raises NudgeIndexError" do
      point_2 = NudgePoint.new
      point_3 = NudgePoint.new
      lambda { BlockPoint.new(point_2, point_3).insert_point_after(5, point_2) }.should raise_error NudgeIndexError, "point index out of range (5 from 3)"
    end
  end
end

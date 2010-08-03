# encoding: UTF-8
require File.expand_path("../nudge", File.dirname(__FILE__))

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
  
  describe "#dup" do
    it "returns a new NudgePoint representing the same Nudge program but without referencing the old NudgePoint objects" do
      ref_point = RefPoint.new(:x)
      block_point = BlockPoint.new(ref_point)
      
      block_duplicate = block_point.dup
      ref_duplicate = block_duplicate.instance_variable_get(:@points).first
      
      block_duplicate.to_script.should == block_point.to_script
      block_duplicate.object_id.should_not == block_point.object_id
      
      ref_duplicate.to_script.should == ref_point.to_script
      ref_duplicate.object_id.should_not == ref_point.object_id
    end
  end
end

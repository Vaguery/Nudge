# encoding: UTF-8
require File.expand_path("../nudge", File.dirname(__FILE__))

describe "NudgeInstruction" do
  describe ":to_nudge_symbol converter" do
    it "should return the class name lowercased, underscored, as a symbol" do
      pending
      BoolNot.to_nudge_symbol.should == :bool_not
      ProportionBoundedAdd.to_nudge_symbol.should == :proportion_bounded_add
    end
    
    it "should replace 'Q' with a question mark with no underscore" do
      pending
      BoolEqualQ.to_nudge_symbol.should == :bool_equal?
      IntGreaterThanQ.to_nudge_symbol.should == :int_greater_than?
    end
  end
  
  describe ":to_nudge_string converter" do
    it "should do what to_nudge_symbol does, but to a string" do
      pending
      BoolNot.to_nudge_string.should == BoolNot.to_nudge_symbol.to_s
      ProportionBoundedAdd.to_nudge_string.should == ProportionBoundedAdd.to_nudge_symbol.to_s
      IntGreaterThanQ.to_nudge_string.should == IntGreaterThanQ.to_nudge_symbol.to_s
    end
  end
  
  describe "to_instruction_classname" do
    it "should return the instruction given into the equivalent class name" do
      pending
      "bool_not".to_instruction_class.should == BoolNot
      "proportion_bounded_add".to_instruction_class.should == ProportionBoundedAdd
      "int_greater_than?".to_instruction_class.should == IntGreaterThanQ
    end
    
    it "should raise an error if the classname doesn't exist" do
      lambda{"bool_guillotine".to_instruction_class}.should raise_error(NameError)
    end
  end
end

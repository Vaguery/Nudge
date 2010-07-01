require 'nudge'

describe "NudgeInstruction" do
  describe ":to_nudge_symbol converter" do
    it "should return the class name lowercased, underscored, as a symbol" do
      BoolNot.to_nudge_symbol.should == :bool_not
      ProportionBoundedAdd.to_nudge_symbol.should == :proportion_bounded_add
    end
    
    it "should replace 'Q' with a question mark with no underscore" do
      BoolEqualQ.to_nudge_symbol.should == :bool_equal?
      IntGreaterThanQ.to_nudge_symbol.should == :int_greater_than?
    end
  end
  
  describe ":to_nudge_string converter" do
    it "should do what to_nudge_symbol does, but to a string" do
      BoolNot.to_nudge_string.should == BoolNot.to_nudge_symbol.to_s
      ProportionBoundedAdd.to_nudge_string.should == ProportionBoundedAdd.to_nudge_symbol.to_s
      IntGreaterThanQ.to_nudge_string.should == IntGreaterThanQ.to_nudge_symbol.to_s
    end
  end
end

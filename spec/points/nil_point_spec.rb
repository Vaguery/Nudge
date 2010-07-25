require './nudge'

describe "NilPoint" do
  describe ".new (source_code: String)" do
    it "returns a new NilPoint containing the given source_code" do
      NilPoint.new("foo bar").instance_variable_get(:@source_code) === "foo bar"
    end
  end
  
  it "should return 0 for #points" do
    NilPoint.new("jansdk").points.should == 0
  end
  
  describe "blueprint" do
    it "should not return any script or values" do
      NilPoint.new("nasdoaosd").script_and_values.should == ["nasdoaosd",[]]
    end
    
    it "should have an the original sourcecode as a script" do
      NilPoint.new("nasdoaosd").to_script.should == "nasdoaosd"
    end
  end
end

#encoding:utf-8
require './nudge'

SCRIPT = "block { block { ref x1 value «int» } do int_add }\n«int» 5"
POINT = NudgePoint.from(SCRIPT)
HASH = {:x1 => Value.new(:int, '100'), :x2 => Value.new(:int, 200)}

describe "Executable" do
  describe ".new(point)" do
    it "returns a new Executable containing a point derived from the given script" do
      NudgePoint.stub!(:from).and_return(POINT)
      Executable.new(SCRIPT).instance_variable_get(:@point).should == POINT
    end
  end
  
  describe "#bind(variable_bindings)" do
    it "returns this Executable with the variable_bindings stored internally" do
      exe = Executable.new(SCRIPT)
      exe.bind(HASH).instance_variable_get(:@variable_bindings).should === HASH
    end
    
    it "overwrites old variable bindings" do
      exe = Executable.new(SCRIPT)
      exe.bind(HASH).bind(:x3 => Value.new(:int, 100)).instance_variable_get(:@variable_bindings)[:x1].should === nil
    end
  end
  
  describe "#run" do
    it "returns a new Outcome" do
      Executable.new(SCRIPT).run.class.should == Outcome
    end
  end
end

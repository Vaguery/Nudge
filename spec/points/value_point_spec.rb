# encoding: UTF-8
require File.expand_path("../../nudge", File.dirname(__FILE__))

describe "ValuePoint" do
  describe ".new (value_type: Symbol, string: String)" do
    it "sets @value_type" do
      point = ValuePoint.new(:int, 5)
      point.instance_variable_get(:@value_type).should == :int
    end
    
    it "sets @string" do
      point = ValuePoint.new(:int, 5)
      point.instance_variable_get(:@string).should == 5
    end
  end
  
  describe "#evaluate (executable: NudgeExecutable)" do
    it "pushes @string to the stack identified by @value_type" do
      exe = NudgeExecutable.new("value «int»\n«int»5")
      ValuePoint.new(:int, "5").evaluate(exe)
      
      exe.stacks[:int].last.should === "5"
    end
    
    it "raises EmptyValue if @string is empty" do
      exe = NudgeExecutable.new("value «int»\n«int»")
      lambda { ValuePoint.new(:int, "").evaluate(exe) }.should raise_error NudgeError::EmptyValue,
        "«int» has no value"
    end
  end
end

require File.join(File.dirname(__FILE__), "./../spec_helper")
include Nudge

describe "Config" do
  it "should have a class #setup method that stores a block" do
    Nudge::Config.should respond_to(:setup)
    Nudge::Config.setup {:foo}
    Nudge::Config.stored_state.should be_a_kind_of(Proc)
    Nudge::Config.stored_state.call.should == :foo
  end
  
end


describe "Settings" do
  before(:each) do
    @s1 = Settings.new
  end
  
  it "should have an Array of active instruction classNames" do
    @s1.instructions.should be_a_kind_of(Array)
  end
  
  it "should default to all instructions defined" do
    @s1.instructions.should == Instruction.all_instructions
  end
  
  it "should have an Array of variable names" do
    @s1.references.should == []
  end
  
  it "should have an Array of active Types" do
    @s1.types.should be_a_kind_of(Array)
  end
  
  it "should default to the Push types" do
    @s1.types.should == NudgeType.push_types
  end
  
  describe "setting the value of Setting#attribute in initialization" do
    it "should allow Hash-values for instructions" do
      bools = [BoolAndInstruction, BoolOrInstruction]
      s2 = Settings.new(:instructions => bools)
      s2.instructions.should == bools
    end
    
    it "should allow Hash-values for types" do
      push = [IntType, BoolType, FloatType]
      s2 = Settings.new(:types => push)
      s2.types.should == push
    end
    
    it "should allow Hash-values for variable names" do
      vars = ["x1", "x3", "y1"]
      s2 = Settings.new(:references => vars)
      s2.references.should == vars
    end
  end
end
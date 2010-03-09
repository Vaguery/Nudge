require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "various DupInstruction types" do
  before(:each) do
    @context = Interpreter.new
    @insts = [
      IntYankdupInstruction.new(@context),
      BoolYankdupInstruction.new(@context),
      FloatYankdupInstruction.new(@context),
      CodeYankdupInstruction.new(@context),
      NameYankdupInstruction.new(@context),
      ExecYankdupInstruction.new(@context)]
  end
  
  
  
  it "should not use clone to produce the new ProgramPoint"
end
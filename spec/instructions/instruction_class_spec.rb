require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Instruction has a master list" do
  it "should have an #all_instructions [getter] method to return a list of every defined instruction" do
    # will be a list of every type subclassed from Instruction
    Instruction.all_instructions.should include(IntAddInstruction)
  end
end
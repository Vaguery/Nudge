require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Instruction has a master list" do
  it "should have an #all_instructions [getter] method to return a list of every defined instruction" do
    # will be a list of every type subclassed from Instruction
    Instruction.all_instructions.should include(IntAddInstruction)
  end
  
  it "should have an #active_instructions [getter] method to return the obvious list" do
    Instruction.active_instructions.should == Instruction.all_instructions
  end
  
  it "should have an #active? method that checks the current list" do
    IntAddInstruction.active?.should == true
  end
  
  it "should have a #deactivate/#activate methods that remove and add the class from the active_instructions" do
    IntAddInstruction.deactivate
    IntAddInstruction.active?.should == false
    IntSubtractInstruction.active?.should == true
    IntAddInstruction.activate
    IntAddInstruction.active?.should == true
    IntSubtractInstruction.active?.should == true
  end
  
  it "should be possible to deactivate all instructions" do
    Instruction.all_instructions.each {|ins| ins.deactivate}
    Instruction.active_instructions.length.should == 0
    Instruction.all_instructions.each {|ins| ins.activate}
    Instruction.active_instructions.length.should > 0
  end
end
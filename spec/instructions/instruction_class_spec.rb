require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge


class TestingInterdependencyInstruction < Instruction
  def preconditions?
    needs IntAddInstruction
  end
end

describe "Instruction has a master list" do
  it "should have an #all_instructions [getter] method to return a list of every defined instruction" do
    # will be a list of every type subclassed from Instruction
    Instruction.all_instructions.should include(IntAddInstruction)
  end
end

describe "capturing errors" do
  describe "NotEnoughStackItems" do
    describe "#preconditions?" do
      it "should push an :error ValuePoint onto the :error stacks when NotEnoughStackItems is raised" do
        context = Interpreter.new
        i1 = IntAddInstruction.new(context)
        lambda{i1.go}.should_not raise_error
        context.stacks[:error].peek.listing.should include "int too small"
      end
    end
  end
  
  describe "MissingInstructionError" do
    it "should push an error if missing interdependent Instruction is identified" do
      context = Interpreter.new
      context.disable(IntAddInstruction)
      i1 = TestingInterdependencyInstruction.new(context)
      lambda{i1.go}.should_not raise_error
      context.stacks[:error].peek.listing.should include "needs IntAddInstruction"
    end
  end
  
end
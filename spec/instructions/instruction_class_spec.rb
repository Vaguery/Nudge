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
        context.stacks[:error].peek.blueprint.should include "int too small"
      end
    end
  end
  
  describe "MissingInstructionError" do
    it "should push an error if missing interdependent Instruction is identified" do
      context = Interpreter.new
      context.disable(IntAddInstruction)
      i1 = TestingInterdependencyInstruction.new(context)
      lambda{i1.go}.should_not raise_error
      context.stacks[:error].peek.blueprint.should include "needs IntAddInstruction"
    end
  end
end


describe ":code stack has a special rule" do
  it "should be impossible to use #pushes to push a :code item that is too large for the context" do
    small_box = Interpreter.new("block {}", code_char_limit:20)
    small_code = ValuePoint.new("code","block { do a }")
    long_code = ValuePoint.new("code","block { do a do b do c do d do e do f do g }")
    throwaway = IntAddInstruction.new(small_box)
    lambda{throwaway.pushes(:code, long_code)}.should raise_error(Instruction::CodeOversizeError)
    lambda{throwaway.pushes(:code, small_code)}.should_not raise_error(Instruction::CodeOversizeError)
  end
end
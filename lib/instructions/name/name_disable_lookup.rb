# Sets the value of the context attribute Interpreter#evaluate_references to false.
# This will persist until the next time the Interpreter evaluates a ReferencePoint;
# instead of attempting to look up the variable or name referred to by the ReferencePoint,
# it will instead push the ReferencePoint onto the +:name: stack.
#
# needs: nothing
#
# pushes: nothing
#
#
#
class NameDisableLookupInstruction < Instruction
  def preconditions?
    true
  end
  def setup
  end
  def derive
  end
  def cleanup
    @context.evaluate_references = false
  end
end

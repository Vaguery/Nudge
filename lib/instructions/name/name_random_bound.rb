# Creates a new ReferencePoint and pushes it onto the +:name+ stack.
# The name will be randomly sampled (with uniform probability) from the union of all
# currently bound variables and names.
#
# needs: at least one bound variable or name
#
# pushes: 1 +:name:
#

class NameRandomBoundInstruction < Instruction
  def preconditions?
    @context.references.length > 0
  end
  def setup
  end
  def derive
    @result = ReferencePoint.new("placeholder")
    @result.randomize(@context)
  end
  def cleanup
    pushes :exec, @result
  end
end

# Implements the K Combinator on the +:exec+ stack:
# deletes the second item (replacing the top one).
#

class ExecKInstruction < Instruction
  def preconditions?
    needs :exec, 2
  end
  def setup
    @keep = @context.pop(:exec)
    @discard = @context.pop(:exec)
  end
  def derive
  end
  def cleanup
    pushes :exec, @keep
  end
end

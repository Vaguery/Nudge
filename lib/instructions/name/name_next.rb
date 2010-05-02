# Creates and pushes a new ReferencePoint onto the +:name+ stack. The name itself
# will be a new string, obtained by invoking the context's Interpreter#next_name method.
#
# needs: nothing
#
# pushes: 1 +:name+

class NameNextInstruction < Instruction
  def preconditions?
    true
  end
  def setup
    @new_name = @context.next_name
  end
  def derive
    @result = ReferencePoint.new(@new_name)
  end
  def cleanup
    pushes :exec, @result
  end
end

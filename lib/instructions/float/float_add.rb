# pops the top 2 items of the +:float+ stack;
# pushes a ValuePoint with their sum onto the +:float+ stack
#
# *needs:* 2 +:float+
#
# *pushes:* 1 +:float+
#

class FloatAddInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg1 = @context.pop_value(:float)
    @arg2 = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("float", @arg1 + @arg2)
  end
  def cleanup
    pushes :float, @result
  end
end

# pops the top item of the +:float+ stack;
# pushes a ValuePoint with its absolute value onto the +:float+ stack
#
# *needs:* 1 +:float+
#
# *pushes:* 1 +:float+
#

class FloatAbsInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("float", @arg1.abs)
  end
  def cleanup
    pushes :float, @result
  end
end

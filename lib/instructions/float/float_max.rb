# pops the top 2 items of the +:float+ stack;
# pushes a new ValuePoint onto the +:float+ stack with the largest of the two values
#
# *needs:* 2 +:float+
#
# *pushes:* 1 +:float+
#

class FloatMaxInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("float", [@arg1, @arg2].max)
  end
  def cleanup
    pushes :float, @result
  end
end

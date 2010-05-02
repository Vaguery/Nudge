# pops the top 2 items of the +:float+ stack;
# pushes a ValuePoint with their difference onto the +:float+ stack
#
# note: the top item is the value subtracted from the second stack item's value
#
# *needs:* 2 +:float+
#
# *pushes:* 1 +:float+
#

class FloatSubtractInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("float", @arg1 - @arg2)
  end
  def cleanup
    pushes :float, @result
  end
end

# pops the top 2 items of the +:float+ stack;
# pushes a new ValuePoint onto the +:bool+ stack, with its value +true+ if the popped values are identical
#
# *needs:* 2 +:float+
#
# *pushes:* 1 +:bool+
#

class FloatEqualQInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
  end
  def derive
      @result = ValuePoint.new("bool", @arg1 == @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end

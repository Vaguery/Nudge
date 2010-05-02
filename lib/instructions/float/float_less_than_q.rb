# pops the top 2 items of the +:float+ stack;
# pushes a new ValuePoint onto the +:bool+ stack,
# with value +true+ if the second one is strictly less than the top one
#
# *needs:* 2 +:float+
#
# *pushes:* 1 +:bool+
#

class FloatLessThanQInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
  end
  def derive
      @result = ValuePoint.new("bool", @arg1 < @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end

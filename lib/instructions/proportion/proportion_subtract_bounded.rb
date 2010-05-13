# pops the top 2 items of the +:proportion+ stack;
# pushes a ValuePoint with their difference (or 0.0, whichever is bigger) onto the +:proportion+ stack
#
# *note:* the first item popped is the number to be subtracted from the other
#
# *needs:* 2 +:proportion+
#
# *pushes:* 1 +:proportion+
#

class ProportionSubtractBoundedInstruction < Instruction
  def preconditions?
    needs :proportion, 2
  end
  def setup
    @arg2 = @context.pop_value(:proportion)
    @arg1 = @context.pop_value(:proportion)
  end
  def derive
    @result = ValuePoint.new("proportion", [@arg1 - @arg2, 0.0].max)
  end
  def cleanup
    pushes :proportion, @result
  end
end

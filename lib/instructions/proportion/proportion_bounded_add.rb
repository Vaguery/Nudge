# pops the top 2 items of the +:proportion+ stack;
# pushes a ValuePoint with their sum (or 1.0, whichever is smaller) onto the +:proportion+ stack
#
# *needs:* 2 +:proportion+
#
# *pushes:* 1 +:proportion+
#

class ProportionBoundedAddInstruction < Instruction
  def preconditions?
    needs :proportion, 2
  end
  def setup
    @arg1 = @context.pop_value(:proportion)
    @arg2 = @context.pop_value(:proportion)
  end
  def derive
    @result = ValuePoint.new("proportion", [@arg1 + @arg2, 1.0].min)
  end
  def cleanup
    pushes :proportion, @result
  end
end

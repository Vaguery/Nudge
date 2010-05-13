# pops the top 2 items of the +:proportion+ stack;
# pushes a new ValuePoint onto the +:proportion+ stack with the smallest of the two values
#
# *needs:* 2 +:proportion+
#
# *pushes:* 1 +:proportion+
#

class ProportionMinInstruction < Instruction
  def preconditions?
    needs :proportion, 2
  end
  def setup
    @arg2 = @context.pop_value(:proportion)
    @arg1 = @context.pop_value(:proportion)
  end
  def derive
    @result = ValuePoint.new("proportion", [@arg1, @arg2].min)
  end
  def cleanup
    pushes :proportion, @result
  end
end

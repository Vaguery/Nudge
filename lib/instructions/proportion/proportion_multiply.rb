# pops the top 2 items of the +:proportion+ stack;
# pushes a ValuePoint with their product onto the +:proportion+ stack
#
# *needs:* 2 +:proportion+
#
# *pushes:* 1 +:proportion+
#

class ProportionMultiplyInstruction < Instruction
  def preconditions?
    needs :proportion, 2
  end
  def setup
    @arg2 = @context.pop_value(:proportion)
    @arg1 = @context.pop_value(:proportion)
  end
  def derive
    @result = ValuePoint.new("proportion", @arg1 * @arg2)
  end
  def cleanup
    pushes :proportion, @result
  end
end

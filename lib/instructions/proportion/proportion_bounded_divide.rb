# pops the top 2 items of the +:proportion+ stack;
# pushes a ValuePoint with their quotient onto the +:proportion+ stack, bounded by [0.0,1.0]
#
# note: the top item is the denominator, the second item is the numerator
#
# note: will push an +:error+ ValuePoint instead of the expected result if the numerator is 0.0
#
# *needs:* 2 +:proportion+
#
# *pushes:* 1 +:proportion+
#

class ProportionBoundedDivideInstruction < Instruction
  def preconditions?
    needs :proportion, 2
  end
  def setup
    @arg2 = @context.pop_value(:proportion)
    @arg1 = @context.pop_value(:proportion)
  end
  def derive
    if @arg2 != 0.0
      quotient = [@arg1/@arg2, 1.0].min
      @result = ValuePoint.new("proportion", quotient)
    else
      raise NaNResultError, "#{self.class} cannot divide by 0.0"
    end
  end
  def cleanup
    pushes :proportion, @result
  end
end

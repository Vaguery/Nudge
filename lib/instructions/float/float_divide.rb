# pops the top 2 items of the +:float+ stack;
# pushes a ValuePoint with their (floating point) quotient onto the +:float+ stack
#
# note: the top item is the denominator, the second item is the numerator
#
# note: will push an +:error+ ValuePoint instead of an +:int+ if the numerator is 0.0
#
# *needs:* 2 +:float+
#
# *pushes:* 1 +:float+
#

class FloatDivideInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
  end
  def derive
    if @arg2 != 0.0
      @quotient = @arg1 / @arg2
      @result = ValuePoint.new("float", @quotient)
    else
      raise NaNResultError, "#{self.class} cannot divide by 0.0"
    end
  end
  def cleanup
    pushes :float, @result
  end
end

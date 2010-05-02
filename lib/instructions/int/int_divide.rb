# pops the top 2 items of the +:int+ stack;
# pushes a ValuePoint with their (integer) quotient onto the +:int+ stack
#
# note: the top item is the denominator, the second item is the numerator
#
# note: will push an +:error+ ValuePoint instead of an +:int+ if the numerator is 0
#
# *needs:* 2 +:int+
#
# *pushes:* 1 +:int+
#

class IntDivideInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
    if @arg2 != 0
      @quotient = @arg1 / @arg2
      @result = ValuePoint.new("int", @quotient)
    else
      raise InstructionMethodError, "#{self.class} cannot divide by 0"
    end
  end
  def cleanup
    pushes :int, @result
  end
end

# pops the top 2 items of the +:int+ stack;
# pushes a ValuePoint with their (integer) remainder onto the +:int+ stack
#
# note: the top item is the denominator, the second item is the numerator
#
# note: will push an +:error+ ValuePoint instead of an +:int+ if the numerator is 0
#
# *needs:* 2 +:int+
#
# *pushes:* 1 +:int+
#

class IntModuloInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
    if @arg2 != 0
      @mod = @arg1 % @arg2
      @result = ValuePoint.new("int", @mod)
    else
      raise InstructionMethodError, "#{self.class} cannot calculate modulo 0"
    end
  end
  def cleanup
    pushes :int, @result
  end
end

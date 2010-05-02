# pops the top 2 items of the +:int+ stack;
# pushes a ValuePoint with value x**y, where x is the second stack item, y the top one
#
# note: the top item is the exponent, the second item is the base
#
# note: will push an +:error+ ValuePoint instead of an +:int+ if asked to take a negative root of 0
#
# *needs:* 2 +:int+
#
# *pushes:* 1 +:int+
#

class IntPowerInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
    raise NaNResultError,"#{self.class} attempted negative root of 0" if @arg1 == 0 && @arg2 < 0
    @result = ValuePoint.new("int", (@arg1**@arg2).to_i)
  end
  def cleanup
    pushes :int, @result
  end
end

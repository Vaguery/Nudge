# pops the top item of the +:int+ stack;
# pushes a ValuePoint with the value negated onto the +:int+ stack
#
# *needs:* 1 +:int+
#
# *pushes:* 1 +:int+
#

class IntNegativeInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg1 = @context.pop_value(:int)
  end
  def derive
      @result = ValuePoint.new("int", -@arg1)
  end
  def cleanup
    pushes :int, @result
  end
end

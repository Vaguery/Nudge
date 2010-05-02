# pops the top 2 items of the +:int+ stack;
# pushes a ValuePoint with their sum onto the +:int+ stack
#
# *needs:* 2 +:int+
#
# *pushes:* 1 +:int+
#

class IntAddInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg1 = @context.pop_value(:int)
    @arg2 = @context.pop_value(:int)
  end
  def derive
    @result = ValuePoint.new("int", @arg1 + @arg2)
  end
  def cleanup
    pushes :int, @result
  end
end

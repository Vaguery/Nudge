# pops the top 2 items of the +:int+ stack;
# pushes a ValuePoint with their difference onto the +:int+ stack
#
# note: the top item is the value subtracted from the second stack item's value
#
# *needs:* 2 +:int+
#
# *pushes:* 1 +:int+
#

class IntSubtractInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
      @diff = @arg1-@arg2
      @result = ValuePoint.new("int", @diff)
  end
  def cleanup
    pushes :int, @result
  end
end

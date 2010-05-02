# pops the top 2 items of the +:float+ stack;
# pushes a new ValuePoint onto the +:float+ stack with the smallest of the two values
#
# *needs:* 2 +:float+
#
# *pushes:* 1 +:float+
#

class FloatMinInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("float", [@arg1, @arg2].min)
  end
  def cleanup
    pushes :float, @result
  end
end

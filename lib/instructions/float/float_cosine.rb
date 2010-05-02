# pops the top item of the +:float+ stack;
# pushes a ValuePoint with its cosine onto the +:float+ stack
#
# *needs:* 1 +:float+
#
# *pushes:* 1 +:float+
#

class FloatCosineInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("float", Math.cos(@arg1))
  end
  def cleanup
    pushes :float, @result
  end
end

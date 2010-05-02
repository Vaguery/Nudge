# pops the top item of the +:float+ stack;
# pushes a ValuePoint with its square root onto the +:float+ stack
#
# note: pushes an +:error+ item if the value is negative
#
# *needs:* 1 +:float+
#
# *pushes:* 1 +:float+
#

class FloatSqrtInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = @context.pop_value(:float)
  end
  def derive
    if @arg1 >= 0.0
      @result = ValuePoint.new("float", Math.sqrt(@arg1))
    else
      raise Instruction::NaNResultError, "#{self.class.to_nudgecode} did not return a float"
    end
  end
  def cleanup
    pushes :float, @result
  end
end

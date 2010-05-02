# pops the top 2 items of the +:float+ stack;
# pushes a ValuePoint with value x**y, where x is the second stack item, y the top one
#
# note: the top item is the exponent, the second item is the base
#
# note: will push an +:error+ ValuePoint instead of a +:float+ if the operation doesn't return a float
#
# *needs:* 2 +:float+
#
# *pushes:* 1 +:float+
#

class FloatPowerInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @exp =  @context.pop_value(:float)
    @base = @context.pop_value(:float)
  end
  def derive
    if !(@base**@exp).nan?
      @result = ValuePoint.new("float", @base**@exp)
    else
      raise Instruction::NaNResultError, "#{self.class.to_nudgecode} did not return a float"
    end
    
  end
  def cleanup
    pushes :float, @result
  end
end

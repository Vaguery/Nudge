# pops the top item of the +:bool+ stack;
# pushes a ValuePoint with the value negated onto the +:bool+ stack
#
# *needs:* 1 +:bool+
#
# *pushes:* 1 +:bool+
#

class BoolNotInstruction < Instruction
  
  def preconditions?
    needs :bool, 1
  end
  
  def setup
    @arg1 = @context.pop_value(:bool)
  end
  
  def derive
    @result = ValuePoint.new("bool", !@arg1)
  end
  
  def cleanup
    pushes :bool, @result
  end
end

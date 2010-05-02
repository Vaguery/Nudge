# pops the top 2 items of the +:bool+ stack;
# pushes a ValuePoint with their logical AND onto the +:bool+ stack
#
# *needs:* 2 +:bool+
#
# *pushes:* 1 +:bool+
#

class BoolAndInstruction < Instruction
  
  def preconditions?
    needs :bool, 2
  end
  
  def setup
    @arg1 = @context.pop_value(:bool)
    @arg2 = @context.pop_value(:bool)
  end
  
  def derive
    @result = ValuePoint.new("bool", @arg1 && @arg2)
  end
  
  def cleanup
    pushes :bool, @result
  end
end
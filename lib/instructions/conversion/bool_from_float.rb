# pops the top +:float+ item;
# pushes a new +:bool+ item,
# with value +false+ when the +:float+ is 0.0, otherwise +true+
#
# *needs:* 1 +:float+
#
# *pushes:* 1 +:bool+
#

class BoolFromFloatInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("bool", @arg != 0.0)
  end
  def cleanup
    pushes :bool, @result
  end
end

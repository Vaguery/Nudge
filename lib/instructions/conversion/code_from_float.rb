# encoding: utf-8

# pops the top +:float+ item;
# pushes a new +:code+ item,
# with value equal to the +:float+ item's blueprint
#
# *needs:* 1 +:float+
#
# *pushes:* 1 +:code+
#

class CodeFromFloatInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("code", "value «float»\n«float» #{@arg}")
  end
  def cleanup
    pushes :code, @result
  end
end

# encoding: utf-8
# pops the top +:bool+ item;
# pushes a new +:code+ item,
# with value equal to the +:bool+ item's blueprint
#
# *needs:* 1 +:bool+
#
# *pushes:* 1 +:code+
#

class CodeFromBoolInstruction < Instruction
  def preconditions?
    needs :bool, 1
  end
  def setup
    @arg = @context.pop_value(:bool)
  end
  def derive
    @result = ValuePoint.new("code", "value «bool»\n«bool» #{@arg}")
  end
  def cleanup
    pushes :code, @result
  end
end

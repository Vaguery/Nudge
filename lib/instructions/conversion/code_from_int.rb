# encoding: utf-8

# pops the top +:int+ item;
# pushes a new +:code+ item,
# with value equal to the +:int+ item's blueprint
#
# *needs:* 1 +:int+
#
# *pushes:* 1 +:code+
#


class CodeFromIntInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg = @context.pop_value(:int)
  end
  def derive
    @result = ValuePoint.new("code", "value «int»\n«int» #{@arg}")
  end
  def cleanup
    pushes :code, @result
  end
end

# encoding: utf-8

# pops the top +:name+ item;
# pushes a new +:code+ item,
# with value equal to the +:name+ item's blueprint
#
# *needs:* 1 +:name+
#
# *pushes:* 1 +:code+
#

class CodeFromNameInstruction < Instruction
  def preconditions?
    needs :name, 1
  end
  def setup
    @arg = @context.pop(:name).name
  end
  def derive
    @result = ValuePoint.new("code", "ref #{@arg}")
  end
  def cleanup
    pushes :code, @result
  end
end

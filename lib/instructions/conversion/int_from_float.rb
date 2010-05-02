# pops the top +:float+ item;
# pushes a new +:int+ item,
# with value obtained by applying #to_i to the value
#
# *needs:* 1 +:float+
#
# *pushes:* 1 +:int+
#

class IntFromFloatInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("int", @arg.to_i)
  end
  def cleanup
    pushes :int, @result
  end
end

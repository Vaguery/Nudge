# pops the top +:int+ item;
# pushes a new +:float+ item,
# with value obtained by applying #to_f to the value
#
# *needs:* 1 +:int+
#
# *pushes:* 1 +:float+
#

class FloatFromIntInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg = @context.pop_value(:int)
  end
  def derive
    @result = ValuePoint.new("float", @arg.to_f)
  end
  def cleanup
    pushes :float, @result
  end
end

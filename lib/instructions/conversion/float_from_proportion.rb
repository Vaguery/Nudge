# pops the top +:proportion+ item;
# pushes a new +:float+ item with the same value
#
# *needs:* 1 +:proportion+
#
# *pushes:* 1 +:float+
#

class FloatFromProportionInstruction < Instruction
  def preconditions?
    needs :proportion, 1
  end
  
  def setup
    @arg = @context.pop_value(:proportion)
  end
  
  def derive
    @result = ValuePoint.new("float", @arg)
  end
  
  def cleanup
    pushes :float, @result
  end
end

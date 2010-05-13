# pops the top +:float+ item;
# pushes a new +:proportion+ item,
# with value obtained by taking the float modulo 1.0
#
# *needs:* 1 +:float+
#
# *pushes:* 1 +:proportion+
#

class ProportionFromFloatInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  
  def setup
    @arg = @context.pop_value(:float)
  end
  
  def derive
    @result = ValuePoint.new("proportion", @arg % 1.0)
  end
  
  def cleanup
    pushes :proportion, @result
  end
end

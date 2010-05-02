# Pops the top +:name+ item, and if it is bound to a name (a local, not a variable)
# it removes that binding.
#
# needs: 1 +:name:
#
# pushes: nothing

class NameUnbindInstruction < Instruction
  def preconditions?
    needs :name,1
  end
  
  def setup
    @arg1 = @context.pop(:name)
  end
  
  def derive
    @lost_name = @arg1.name
  end
  
  def cleanup
    @context.unbind_name(@lost_name)
  end
end

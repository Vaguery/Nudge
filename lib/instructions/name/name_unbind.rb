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

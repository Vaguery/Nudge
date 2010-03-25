class BoolNotInstruction < Instruction
  
  def preconditions?
    needs :bool, 1
  end
  
  def setup
    @arg1 = @context.pop_value(:bool)
  end
  
  def derive
    @result = ValuePoint.new("bool", !@arg1)
  end
  
  def cleanup
    pushes :bool, @result
  end
end

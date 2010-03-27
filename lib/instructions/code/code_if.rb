class CodeIfInstruction < Instruction
  
  def preconditions?
    needs :code, 2
    needs :bool, 1
  end
  
  def setup
    @stay = @context.pop_value(:bool)
    @ifFalse = @context.pop_value(:code)
    @ifTrue = @context.pop_value(:code)
  end
  
  def derive
    which = @stay ? @ifTrue : @ifFalse
    @result = NudgeProgram.new(which).linked_code
  end
  
  def cleanup
    pushes :exec, @result
  end
end
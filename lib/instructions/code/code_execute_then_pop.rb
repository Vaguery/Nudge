class CodeExecuteThenPopInstruction < Instruction
  def preconditions?
    needs CodePopInstruction
    needs :code, 1
  end
  def setup
    @arg = @context.peek_value(:code) # does not pop the stack initially!
  end
  def derive
    that_becomes = NudgeProgram.new(@arg)
    if that_becomes.parses?
      @result = CodeblockPoint.new([NudgeProgram.new(@arg).linked_code,InstructionPoint.new("code_pop")])
    else
      @result = CodeblockPoint.new([InstructionPoint.new("code_pop")])
    end
  end
  def cleanup
    pushes :exec, @result
  end
end

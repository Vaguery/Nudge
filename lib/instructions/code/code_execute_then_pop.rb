# peeks at the top item from the +:code+ stack (without popping it!);
# pushes a new block containing that code value and "do code_pop" onto the +:exec+ stack,
# so the item is executed, then removed from the +:code+ stack
#
# *needs:* 1 +:code+
#
# *pushes:* 1 +:exec+
#

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

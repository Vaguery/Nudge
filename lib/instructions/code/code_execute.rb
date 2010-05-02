# pops the top item from the +:code+ stack;
# pushes it onto the +:exec+ stack so it is executed
#
# *needs:* 1 +:code+
#
# *pushes:* 1 +:exec+

class CodeExecuteInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    @arg = @context.pop_value(:code)
  end
  def derive
    that_becomes = NudgeProgram.new(@arg)
    if that_becomes.parses?
      @result = NudgeProgram.new(@arg).linked_code
    else
      @result = CodeblockPoint.new([])
    end
  end
  def cleanup
    pushes :exec, @result
  end
end

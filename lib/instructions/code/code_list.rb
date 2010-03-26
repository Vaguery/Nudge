class CodeListInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    listed = []
    listed << NudgeProgram.new(@arg1).linked_code unless @arg1 == ""
    listed << NudgeProgram.new(@arg2).linked_code unless @arg2 == ""
    combined = CodeblockPoint.new(listed).listing
    @result = ValuePoint.new("code", combined)
  end
  def cleanup
    pushes :code, @result
  end
end

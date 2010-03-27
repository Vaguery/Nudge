class ExecYInstruction < Instruction
  def preconditions?
    needs :exec, 1
  end
  def setup
    @arg1 = @context.pop(:exec)
  end
  def derive
    @recurser = CodeblockPoint.new([InstructionPoint.new("exec_y"),@arg1])
  end
  def cleanup
    pushes :exec, @recurser
    pushes :exec, @arg1
  end
end

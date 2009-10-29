class ExecPopInstruction < Instruction
  def preconditions?
    needs :exec, 1
  end
  def setup
  end
  def derive
    @goAway = @context.stacks[:exec].pop
  end
  def cleanup
  end
end

class ExecYInstruction < Instruction
  def preconditions?
    needs :exec, 1
  end
  def setup
    @arg1 = @context.stacks[:exec].pop
  end
  def derive
    @result = CodeBlock.new("block {do exec_y #{@arg1.listing}}")
  end
  def cleanup
    pushes :exec, @result
    pushes :exec, @arg1
  end
end

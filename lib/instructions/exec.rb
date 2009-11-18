class ExecYInstruction < Instruction
  def preconditions?
    needs :exec, 1
  end
  def setup
    @arg1 = @context.stacks[:exec].pop
  end
  def derive
    @recurser = CodeBlock.new("block {do exec_y #{@arg1.listing}}")
  end
  def cleanup
    pushes :exec, @recurser
    pushes :exec, @arg1
  end
end


class ExecKInstruction < Instruction
  def preconditions?
    needs :exec, 2
  end
  def setup
    @keep = @context.stacks[:exec].pop
    @discard = @context.stacks[:exec].pop
  end
  def derive
  end
  def cleanup
    pushes :exec, @keep
  end
end


class ExecSInstruction < Instruction
  def preconditions?
    needs :exec, 3
  end
  def setup
    @argA = @context.stacks[:exec].pop
    @argB = @context.stacks[:exec].pop
    @argC = @context.stacks[:exec].pop
  end
  def derive  
    @s_result = CodeBlock.new("block {#{@argB.listing} #{@argC.listing}}")
  end
  def cleanup
    pushes :exec, @s_result
    pushes :exec, @argC
    pushes :exec, @argA
  end
end
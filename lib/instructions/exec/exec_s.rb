class ExecSInstruction < Instruction
  def preconditions?
    needs :exec, 3
  end
  def setup
    @argA = @context.pop(:exec)
    @argB = @context.pop(:exec)
    @argC = @context.pop(:exec)
  end
  def derive  
    @s_result = CodeblockPoint.new([@argB,@argC])
  end
  def cleanup
    pushes :exec, @s_result
    pushes :exec, @argC
    pushes :exec, @argA
  end
end

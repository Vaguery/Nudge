class ExecDoCountInstruction < Instruction
  def preconditions?
    needs ExecDoRangeInstruction
    needs :exec, 1
    needs :int, 1
  end
  
  def setup
    @destination = @context.pop(:int)
    @code = @context.pop(:exec)
  end
  
  def derive
    raise InstructionMethodError, "#{self.class} needs a positive argument" if @destination.value < 1
    @one_less = ValuePoint.new("int",@destination.value-1)
  end
  
  def cleanup
    recursor = CodeblockPoint.new([ValuePoint.new("int",0), @one_less,
      InstructionPoint.new("exec_do_range"),@code])
    pushes :exec, recursor
  end
end
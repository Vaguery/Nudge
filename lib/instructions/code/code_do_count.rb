# Again, the original description of this instruction appears to be confusing "CODE.DO*RANGE" with "EXEC.DO*RANGE"; I've made the adjustment to the code so that the behavior is as described, not the implementation.

class CodeDoCountInstruction < Instruction
  def preconditions?
    needs ExecDoRangeInstruction
    needs :code, 1
    needs :int, 1
  end
  
  def setup
    @destination = @context.pop(:int)
    @code = @context.pop_value(:code)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} needs a positive argument" if @destination.value < 1
  end
  
  def derive
    @codeblock = NudgeProgram.new(@code).linked_code
    @one_less = ValuePoint.new("int",@destination.value-1)
  end
  
  def cleanup
    recursor = CodeblockPoint.new([ValuePoint.new("int",0), @one_less,
      InstructionPoint.new("exec_do_range"),@codeblock])
    pushes :exec, recursor
  end
end

# Again, the original description of this instruction appears to be confusing "CODE.DO*RANGE" with "EXEC.DO*RANGE"; I've made the adjustment to the code so that the behavior is as described, not the implementation.

class CodeDoTimesInstruction < Instruction
  def preconditions?
    needs ExecDoTimesInstruction
    needs :code, 1
    needs :int, 2
  end
  
  def setup
    @destination = @context.pop(:int)
    @counter = @context.pop(:int)
    @code = @context.pop_value(:code)
  end
  
  def derive
    @finished = false
    if @counter.value == @destination.value
      @finished = true
    elsif @counter.value < @destination.value
      @new_counter = ValuePoint.new("int", @counter.value + 1)
    else
      @new_counter = ValuePoint.new("int", @counter.value - 1)
    end
    @codeblock = NudgeProgram.new(@code).linked_code
  end
  
  def cleanup
    if @finished
      pushes :exec, @codeblock
    else
      recursor = CodeblockPoint.new([@new_counter, @destination,
        InstructionPoint.new("exec_do_times"),@codeblock])
      pushes :exec, recursor
      pushes :exec, @codeblock
    end
  end
end

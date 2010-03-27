class ExecDoTimesInstruction < Instruction
  def preconditions?
    needs :exec, 1
    needs :int, 2
  end
  
  def setup
    @destination = @context.pop(:int)
    @counter = @context.pop(:int)
    @code = @context.pop(:exec)
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
  end
  
  def cleanup
    if @finished
      pushes :exec, @code
    else
      recursor = CodeblockPoint.new([@new_counter, @destination,
        InstructionPoint.new("exec_do_times"),@code])
      pushes :exec, recursor
      pushes :exec, @code
    end
  end
end

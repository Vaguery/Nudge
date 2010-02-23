class ExecYInstruction < Instruction
  def preconditions?
    needs :exec, 1
  end
  def setup
    @arg1 = @context.stacks[:exec].pop
  end
  def derive
    @recurser = CodeblockPoint.new([InstructionPoint.new("exec_y"),@arg1])
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
    @s_result = CodeblockPoint.new([@argB,@argC])
  end
  def cleanup
    pushes :exec, @s_result
    pushes :exec, @argC
    pushes :exec, @argA
  end
end


class ExecDoRangeInstruction < Instruction
  def preconditions?
    needs :exec, 1
    needs :int, 2
  end
  
  def setup
    @destination = @context.stacks[:int].pop
    @counter = @context.stacks[:int].pop
    @code = @context.stacks[:exec].pop
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
      pushes :int, @counter
      pushes :exec, @code
    else
      recursor = CodeblockPoint.new([@new_counter, @destination,
        InstructionPoint.new("exec_do_range"),@code])
      pushes :int, @counter
      pushes :exec, recursor
      pushes :exec, @code
    end
  end
end


class ExecDoTimesInstruction < Instruction
  def preconditions?
    needs :exec, 1
    needs :int, 2
  end
  
  def setup
    @destination = @context.stacks[:int].pop
    @counter = @context.stacks[:int].pop
    @code = @context.stacks[:exec].pop
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


class ExecDoCountInstruction < Instruction
  def preconditions?
    unless @context.instructions.include?(ExecDoRangeInstruction)
      raise(MissingInstructionError, "exec_do_range must be active to use exec_do_count") 
    end
    needs :exec, 1
    needs :int, 1
  end
  
  def setup
    if @context.stacks[:int].peek.value < 1
      raise InstructionMethodError
    end
    @destination = @context.stacks[:int].pop
    @code = @context.stacks[:exec].pop
  end
  
  def derive
    @one_less = ValuePoint.new("int",@destination.value-1)
  end
  
  def cleanup
    recursor = CodeblockPoint.new([ValuePoint.new("int",0), @one_less,
      InstructionPoint.new("exec_do_range"),@code])
    pushes :exec, recursor
  end
end
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


class ExecKInstruction < Instruction
  def preconditions?
    needs :exec, 2
  end
  def setup
    @keep = @context.pop(:exec)
    @discard = @context.pop(:exec)
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


class ExecDoRangeInstruction < Instruction
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
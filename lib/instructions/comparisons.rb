class IntEqualQInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.stacks[:int].pop.value
    @arg1 = @context.stacks[:int].pop.value
  end
  def derive
      @result = LiteralPoint.new("bool", @arg1 == @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end


class IntLessThanQInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.stacks[:int].pop.value
    @arg1 = @context.stacks[:int].pop.value
  end
  def derive
      @result = LiteralPoint.new("bool", @arg1 < @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end


class IntGreaterThanQInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.stacks[:int].pop.value
    @arg1 = @context.stacks[:int].pop.value
  end
  def derive
      @result = LiteralPoint.new("bool", @arg1 > @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end


class FloatGreaterThanQInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.stacks[:float].pop.value
    @arg1 = @context.stacks[:float].pop.value
  end
  def derive
      @result = LiteralPoint.new("bool", @arg1 > @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end


class FloatLessThanQInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.stacks[:float].pop.value
    @arg1 = @context.stacks[:float].pop.value
  end
  def derive
      @result = LiteralPoint.new("bool", @arg1 < @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end
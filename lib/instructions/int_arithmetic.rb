class IntAddInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg1 = Stack.stacks[:int].pop
    @arg2 = Stack.stacks[:int].pop
  end
  def derive
    @result = LiteralPoint.new("int", @arg1.value + @arg2.value)
  end
  def cleanup
    pushes :int, @result
  end
end

class IntMultiplyInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg1 = Stack.stacks[:int].pop
    @arg2 = Stack.stacks[:int].pop
  end
  def derive
    @result = LiteralPoint.new("int", @arg1.value * @arg2.value)
  end
  def cleanup
    pushes :int, @result
  end
end


class IntDivideInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = Stack.stacks[:int].pop.value
    @arg1 = Stack.stacks[:int].pop.value
  end
  def derive
    if @arg2 != 0
      @quotient = @arg1 / @arg2
      @result = LiteralPoint.new("int", @quotient)
    else
      raise InstructionMethodError
    end
  end
  def cleanup
    pushes :int, @result
  end
end


class IntSubtractInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = Stack.stacks[:int].pop.value
    @arg1 = Stack.stacks[:int].pop.value
  end
  def derive
      @diff = @arg1-@arg2
      @result = LiteralPoint.new("int", @diff)
  end
  def cleanup
    pushes :int, @result
  end
end


class IntModuloInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = Stack.stacks[:int].pop.value
    @arg1 = Stack.stacks[:int].pop.value
  end
  def derive
    if @arg2 != 0
      @mod = @arg1 % @arg2
      @result = LiteralPoint.new("int", @mod)
    else
      raise InstructionMethodError
    end
  end
  def cleanup
    pushes :int, @result
  end
end


class IntMaxInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = Stack.stacks[:int].pop.value
    @arg1 = Stack.stacks[:int].pop.value
  end
  def derive
      @max = [@arg1,@arg2].max
      @result = LiteralPoint.new("int", @max)
  end
  def cleanup
    pushes :int, @result
  end
end


class IntMinInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = Stack.stacks[:int].pop.value
    @arg1 = Stack.stacks[:int].pop.value
  end
  def derive
      @min = [@arg1,@arg2].min
      @result = LiteralPoint.new("int", @min)
  end
  def cleanup
    pushes :int, @result
  end
end


class IntAbsInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg1 = Stack.stacks[:int].pop.value
  end
  def derive
      @result = LiteralPoint.new("int", @arg1.abs)
  end
  def cleanup
    pushes :int, @result
  end
end
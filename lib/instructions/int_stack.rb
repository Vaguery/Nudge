class IntPopInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @result = Stack.stacks[:int].pop
  end
  def derive
  end
  def cleanup
  end
end


class IntSwapInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @result1 = Stack.stacks[:int].pop
    @result2 = Stack.stacks[:int].pop
  end
  def derive
  end
  def cleanup
    pushes :int, @result1
    pushes :int, @result2
  end
end


class IntDuplicateInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg1 = Stack.stacks[:int].peek.value
  end
  def derive
    @result = LiteralPoint.new("int",@arg1)
  end
  def cleanup
    pushes :int, @result
  end
end


class IntRotateInstruction < Instruction
  def preconditions?
    needs :int, 3
  end
  def setup
    @arg3 = Stack.stacks[:int].pop
    @arg2 = Stack.stacks[:int].pop
    @arg1 = Stack.stacks[:int].pop
  end
  def derive
  end
  def cleanup
    pushes :int, @arg2
    pushes :int, @arg3
    pushes :int, @arg1
  end
end


class IntDepthInstruction < Instruction
  def preconditions?
    Stack.stacks[:int].depth != nil
  end
  def setup
  end
  def derive
    @result = LiteralPoint.new("int",Stack.stacks[:int].depth)
  end
  def cleanup
    pushes :int, @result
  end
end


class IntFlushInstruction < Instruction
  def preconditions?
    Stack.stacks[:int].depth != nil
  end
  def setup
  end
  def derive
  end
  def cleanup
    Stack.stacks[:int].clear
  end
end

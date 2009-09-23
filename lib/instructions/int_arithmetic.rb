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
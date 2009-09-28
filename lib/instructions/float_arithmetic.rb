class FloatAddInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg1 = Stack.stacks[:float].pop.value
    @arg2 = Stack.stacks[:float].pop.value
  end
  def derive
    @result = LiteralPoint.new("float", @arg1 + @arg2)
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatMultiplyInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg1 = Stack.stacks[:float].pop.value
    @arg2 = Stack.stacks[:float].pop.value
  end
  def derive
    @result = LiteralPoint.new("float", @arg1 * @arg2)
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatSubtractInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = Stack.stacks[:float].pop.value
    @arg1 = Stack.stacks[:float].pop.value
  end
  def derive
    @result = LiteralPoint.new("float", @arg1 - @arg2)
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatDivideInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = Stack.stacks[:float].pop.value
    @arg1 = Stack.stacks[:float].pop.value
  end
  def derive
    if @arg2 != 0.0
      @quotient = @arg1 / @arg2
      @result = LiteralPoint.new("float", @quotient)
    else
      raise InstructionMethodError
    end
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatMaxInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = Stack.stacks[:float].pop.value
    @arg1 = Stack.stacks[:float].pop.value
  end
  def derive
    @result = LiteralPoint.new("float", [@arg1, @arg2].max)
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatMinInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = Stack.stacks[:float].pop.value
    @arg1 = Stack.stacks[:float].pop.value
  end
  def derive
    @result = LiteralPoint.new("float", [@arg1, @arg2].min)
  end
  def cleanup
    pushes :float, @result
  end
end

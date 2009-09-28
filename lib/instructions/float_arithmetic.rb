class FloatAddInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg1 = Stack.stacks[:float].pop
    @arg2 = Stack.stacks[:float].pop
  end
  def derive
    @result = LiteralPoint.new("float", @arg1.value + @arg2.value)
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

class FloatSineInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = Stack.stacks[:float].pop.value
  end
  def derive
    @result = LiteralPoint.new("float", Math.sin(@arg1))
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatCosineInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = Stack.stacks[:float].pop.value
  end
  def derive
    @result = LiteralPoint.new("float", Math.cos(@arg1))
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatTangentInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = Stack.stacks[:float].pop.value
  end
  def derive
    @result = LiteralPoint.new("float", Math.tan(@arg1))
  end
  def cleanup
    pushes :float, @result
  end
end


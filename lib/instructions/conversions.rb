class IntFromBoolInstruction < Instruction
  def preconditions?
    needs :bool, 1
  end
  def setup
    @arg = Stack.stacks[:bool].pop.value
  end
  def derive
    @result = LiteralPoint.new("int", @arg ? 1 : 0)
  end
  def cleanup
    pushes :int, @result
  end
end


class FloatFromBoolInstruction < Instruction
  def preconditions?
    needs :bool, 1
  end
  def setup
    @arg = Stack.stacks[:bool].pop.value
  end
  def derive
    @result = LiteralPoint.new("float", @arg ? 1.0 : 0.0)
  end
  def cleanup
    pushes :float, @result
  end
end


class IntFromFloatInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg = Stack.stacks[:float].pop.value
  end
  def derive
    @result = LiteralPoint.new("int", @arg.to_i)
  end
  def cleanup
    pushes :int, @result
  end
end


class FloatFromIntInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg = Stack.stacks[:int].pop.value
  end
  def derive
    @result = LiteralPoint.new("float", @arg.to_f)
  end
  def cleanup
    pushes :float, @result
  end
end


class BoolFromIntInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg = Stack.stacks[:int].pop.value
  end
  def derive
    @result = LiteralPoint.new("bool", @arg != 0)
  end
  def cleanup
    pushes :bool, @result
  end
end


class BoolFromFloatInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg = Stack.stacks[:float].pop.value
  end
  def derive
    @result = LiteralPoint.new("bool", @arg != 0.0)
  end
  def cleanup
    pushes :bool, @result
  end
end
class BoolAndInstruction < Instruction
  def preconditions?
    needs :bool, 2
  end
  def setup
    @arg1 = Stack.stacks[:bool].pop.value
    @arg2 = Stack.stacks[:bool].pop.value
  end
  def derive
    @result = LiteralPoint.new("bool", @arg1 && @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end


class BoolOrInstruction < Instruction
  def preconditions?
    needs :bool, 2
  end
  def setup
    @arg1 = Stack.stacks[:bool].pop.value
    @arg2 = Stack.stacks[:bool].pop.value
  end
  def derive
    @result = LiteralPoint.new("bool", @arg1 || @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end


class BoolXorInstruction < Instruction
  def preconditions?
    needs :bool, 2
  end
  def setup
    @arg1 = Stack.stacks[:bool].pop.value
    @arg2 = Stack.stacks[:bool].pop.value
  end
  def derive
    @result = LiteralPoint.new("bool", @arg1 != @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end



class BoolEqualQInstruction < Instruction
  def preconditions?
    needs :bool, 2
  end
  def setup
    @arg1 = Stack.stacks[:bool].pop.value
    @arg2 = Stack.stacks[:bool].pop.value
  end
  def derive
    @result = LiteralPoint.new("bool", @arg1 == @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end




class BoolNotInstruction < Instruction
  def preconditions?
    needs :bool, 1
  end
  def setup
    @arg1 = Stack.stacks[:bool].pop.value
  end
  def derive
    @result = LiteralPoint.new("bool", !@arg1)
  end
  def cleanup
    pushes :bool, @result
  end
end

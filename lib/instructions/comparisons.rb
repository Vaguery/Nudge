class IntEqualQInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.stacks[:int].pop.value
    @arg1 = @context.stacks[:int].pop.value
  end
  def derive
      @result = ValuePoint.new("bool", @arg1 == @arg2)
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
      @result = ValuePoint.new("bool", @arg1 < @arg2)
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
      @result = ValuePoint.new("bool", @arg1 > @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end


class FloatEqualQInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.stacks[:float].pop.value
    @arg1 = @context.stacks[:float].pop.value
  end
  def derive
      @result = ValuePoint.new("bool", @arg1 == @arg2)
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
      @result = ValuePoint.new("bool", @arg1 > @arg2)
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
      @result = ValuePoint.new("bool", @arg1 < @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end


class ExecEqualQInstruction < Instruction
  def preconditions?
    needs :exec, 2
  end
  def setup
    @arg2 = @context.stacks[:exec].pop.listing
    @arg1 = @context.stacks[:exec].pop.listing
  end
  def derive
    x1 = NudgeProgram.new(@arg1).listing
    x2 = NudgeProgram.new(@arg2).listing
    @result = ValuePoint.new("bool", x1 == x2)
  end
  def cleanup
    pushes :bool, @result
  end
end



class NameEqualQInstruction < Instruction
  def preconditions?
    needs :name, 2
  end
  def setup
    @arg2 = @context.stacks[:name].pop.value
    @arg1 = @context.stacks[:name].pop.value
  end
  def derive
    @result = ValuePoint.new("bool", @arg1 == @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end


class CodeEqualQInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.stacks[:code].pop.value
    @arg1 = @context.stacks[:code].pop.value
  end
  def derive
    c1 = NudgeProgram.new(@arg1).listing
    c2 = NudgeProgram.new(@arg2).listing
    @result = ValuePoint.new("bool", c1 == c2)
  end
  def cleanup
    pushes :bool, @result
  end
end


class FloatAddInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg1 = @context.stacks[:float].pop.value
    @arg2 = @context.stacks[:float].pop.value
  end
  def derive
    @result = ValuePoint.new("float", @arg1 + @arg2)
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
    @arg1 = @context.stacks[:float].pop.value
    @arg2 = @context.stacks[:float].pop.value
  end
  def derive
    @result = ValuePoint.new("float", @arg1 * @arg2)
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
    @arg2 = @context.stacks[:float].pop.value
    @arg1 = @context.stacks[:float].pop.value
  end
  def derive
    @result = ValuePoint.new("float", @arg1 - @arg2)
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
    @arg2 = @context.stacks[:float].pop.value
    @arg1 = @context.stacks[:float].pop.value
  end
  def derive
    if @arg2 != 0.0
      @quotient = @arg1 / @arg2
      @result = ValuePoint.new("float", @quotient)
    else
      raise NaNResultError, "#{self.class} cannot divide by 0.0"
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
    @arg2 = @context.stacks[:float].pop.value
    @arg1 = @context.stacks[:float].pop.value
  end
  def derive
    @result = ValuePoint.new("float", [@arg1, @arg2].max)
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
    @arg2 = @context.stacks[:float].pop.value
    @arg1 = @context.stacks[:float].pop.value
  end
  def derive
    @result = ValuePoint.new("float", [@arg1, @arg2].min)
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatNegativeInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = @context.stacks[:float].pop.value
  end
  def derive
    @result = ValuePoint.new("float", -@arg1)
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatAbsInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = @context.stacks[:float].pop.value
  end
  def derive
    @result = ValuePoint.new("float", @arg1.abs)
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatPowerInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @exp = @context.stacks[:float].pop.value
    @base = @context.stacks[:float].pop.value
  end
  def derive
    if !(@base**@exp).nan?
      @result = ValuePoint.new("float", @base**@exp)
    else
      raise Instruction::NaNResultError, "#{self.class.to_nudgecode} did not return a float"
    end
    
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatSqrtInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = @context.stacks[:float].pop.value
  end
  def derive
    if @arg1 >= 0.0
      @result = ValuePoint.new("float", Math.sqrt(@arg1))
    else
      raise Instruction::NaNResultError, "#{self.class.to_nudgecode} did not return a float"
    end
  end
  def cleanup
    pushes :float, @result
  end
end


class FloatModuloInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.stacks[:float].pop.value
    @arg1 = @context.stacks[:float].pop.value
  end
  def derive
    if @arg2 != 0
      @mod = @arg1 % @arg2
      @result = ValuePoint.new("float", @mod)
    else
      raise NaNResultError, "#{self.class} attempted modulo 0.0"
    end
  end
  def cleanup
    pushes :float, @result
  end
end

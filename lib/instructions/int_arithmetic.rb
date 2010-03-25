class IntAddInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg1 = @context.pop_value(:int)
    @arg2 = @context.pop_value(:int)
  end
  def derive
    @result = ValuePoint.new("int", @arg1 + @arg2)
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
    @arg1 = @context.pop_value(:int)
    @arg2 = @context.pop_value(:int)
  end
  def derive
    @result = ValuePoint.new("int", @arg1 * @arg2)
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
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
    if @arg2 != 0
      @quotient = @arg1 / @arg2
      @result = ValuePoint.new("int", @quotient)
    else
      raise InstructionMethodError, "#{self.class} cannot divide by 0"
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
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
      @diff = @arg1-@arg2
      @result = ValuePoint.new("int", @diff)
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
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
    if @arg2 != 0
      @mod = @arg1 % @arg2
      @result = ValuePoint.new("int", @mod)
    else
      raise InstructionMethodError, "#{self.class} cannot calculate modulo 0"
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
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
      @max = [@arg1,@arg2].max
      @result = ValuePoint.new("int", @max)
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
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
      @min = [@arg1,@arg2].min
      @result = ValuePoint.new("int", @min)
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
    @arg1 = @context.pop_value(:int)
  end
  def derive
      @result = ValuePoint.new("int", @arg1.abs)
  end
  def cleanup
    pushes :int, @result
  end
end



class IntNegativeInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg1 = @context.pop_value(:int)
  end
  def derive
      @result = ValuePoint.new("int", -@arg1)
  end
  def cleanup
    pushes :int, @result
  end
end



class IntPowerInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
    raise NaNResultError,"#{self.class} attempted negative root of 0" if @arg1 == 0 && @arg2 < 0
    @result = ValuePoint.new("int", (@arg1**@arg2).to_i)
  end
  def cleanup
    pushes :int, @result
  end
end


class IntEqualQInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
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
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
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
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
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
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
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
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
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
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
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
    @arg2 = @context.pop(:exec).listing
    @arg1 = @context.pop(:exec).listing
  end
  def derive
    x1 = NudgeProgram.new(@arg1)
    x2 = NudgeProgram.new(@arg2)
    @result = ValuePoint.new("bool", x1.listing == x2.listing)
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
    @arg2 = @context.pop_value(:name)
    @arg1 = @context.pop_value(:name)
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
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
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


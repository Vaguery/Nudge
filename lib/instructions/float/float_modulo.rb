class FloatModuloInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
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

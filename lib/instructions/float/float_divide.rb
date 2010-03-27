class FloatDivideInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
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

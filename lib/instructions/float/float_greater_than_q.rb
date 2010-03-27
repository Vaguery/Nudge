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

class FloatMultiplyInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg1 = @context.pop_value(:float)
    @arg2 = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("float", @arg1 * @arg2)
  end
  def cleanup
    pushes :float, @result
  end
end

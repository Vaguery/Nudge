class FloatFromBoolInstruction < Instruction
  def preconditions?
    needs :bool, 1
  end
  def setup
    @arg = @context.pop_value(:bool)
  end
  def derive
    @result = ValuePoint.new("float", @arg ? 1.0 : 0.0)
  end
  def cleanup
    pushes :float, @result
  end
end

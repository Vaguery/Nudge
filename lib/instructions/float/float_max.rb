class FloatMaxInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @arg2 = @context.pop_value(:float)
    @arg1 = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("float", [@arg1, @arg2].max)
  end
  def cleanup
    pushes :float, @result
  end
end

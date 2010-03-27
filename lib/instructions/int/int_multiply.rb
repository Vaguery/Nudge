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

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

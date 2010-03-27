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

class IntMinInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
      @min = [@arg1,@arg2].min
      @result = ValuePoint.new("int", @min)
  end
  def cleanup
    pushes :int, @result
  end
end

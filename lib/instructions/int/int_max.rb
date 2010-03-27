class IntMaxInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
      @max = [@arg1,@arg2].max
      @result = ValuePoint.new("int", @max)
  end
  def cleanup
    pushes :int, @result
  end
end

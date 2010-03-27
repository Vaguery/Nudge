class IntFromFloatInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("int", @arg.to_i)
  end
  def cleanup
    pushes :int, @result
  end
end

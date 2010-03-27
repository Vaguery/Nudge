class FloatFromIntInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg = @context.pop_value(:int)
  end
  def derive
    @result = ValuePoint.new("float", @arg.to_f)
  end
  def cleanup
    pushes :float, @result
  end
end

class FloatTangentInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("float", Math.tan(@arg1))
  end
  def cleanup
    pushes :float, @result
  end
end

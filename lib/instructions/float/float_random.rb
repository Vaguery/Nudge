class FloatRandomInstruction < Instruction
  def preconditions?
    true # no preconditions
  end
  def setup
  end
  def derive
    @result = ValuePoint.new("float", FloatType.any_value)
  end
  def cleanup
    pushes :float, @result
  end
end

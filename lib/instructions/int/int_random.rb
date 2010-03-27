class IntRandomInstruction < Instruction
  def preconditions?
    true # no preconditions
  end
  def setup
  end
  def derive
    @result = ValuePoint.new("int", IntType.any_value)
  end
  def cleanup
    pushes :int, @result
  end
end

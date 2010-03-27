class BoolRandomInstruction < Instruction
  def preconditions?
    true # no preconditions
  end
  def setup
  end
  def derive
    @result = ValuePoint.new("bool", BoolType.any_value)
  end
  def cleanup
    pushes :bool, @result
  end
end

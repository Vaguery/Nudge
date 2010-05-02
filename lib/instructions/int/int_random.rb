# pushes a new +:int+ ValuePoint, with value determined by a call to IntType.any_value
#

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

# pushes a new +:bool+ ValuePoint, with value determined by a call to BoolType.any_value
#

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

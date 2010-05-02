# pushes a new +:float+ ValuePoint, with value determined by a call to FloatType.any_value
#

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

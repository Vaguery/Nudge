# does nothing
#

class CodeNoopInstruction < Instruction
  def preconditions?
    true
  end

  def setup
  end

  def derive
  end

  def cleanup
  end
end

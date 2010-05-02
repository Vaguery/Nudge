# pops (and discards) the topmost item from the +:float+ stack
#

class FloatPopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :float)
  end
end

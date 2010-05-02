# pops (and discards) the topmost item from the +:bool+ stack
#

class BoolPopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :bool)
  end
end

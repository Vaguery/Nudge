# pops (and discards) the topmost item from the +:int+ stack
#

class IntPopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :int)
  end
end

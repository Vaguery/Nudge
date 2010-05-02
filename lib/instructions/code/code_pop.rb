# pops (and discards) the topmost item from the +:code+ stack
#

class CodePopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :code)
  end
end

# pops (and discards) the topmost item from the +:exec+ stack
#

class ExecPopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :exec)
  end
end

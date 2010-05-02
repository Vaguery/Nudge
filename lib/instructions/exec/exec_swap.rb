# exchanges the position of the top 2 items on the +:exec+ stack
#

class ExecSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :exec)
  end
end

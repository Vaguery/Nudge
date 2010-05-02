# exchanges the position of the top 2 items on the +:code+ stack
#

class CodeSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :code)
  end
end

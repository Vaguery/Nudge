# exchanges the position of the top 2 items on the +:int+ stack
#

class IntSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :int)
  end
end

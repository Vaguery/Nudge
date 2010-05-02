# exchanges the position of the top 2 items on the +:bool+ stack
#

class BoolSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :bool)
  end
end

# exchanges the position of the top 2 items on the +:float+ stack
#

class FloatSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :float)
  end
end

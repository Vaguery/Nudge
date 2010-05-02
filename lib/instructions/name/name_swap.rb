# exchanges the position of the top 2 items on the +:name+ stack
#

class NameSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :name)
  end
end

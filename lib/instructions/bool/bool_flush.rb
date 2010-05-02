# deletes all items from the +:bool+ stack
#

class BoolFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :bool)
  end
end

# deletes all items from the +:int+ stack
#

class IntFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :int)
  end
end

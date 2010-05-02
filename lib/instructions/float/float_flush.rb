# deletes all items from the +:float+ stack
#

class FloatFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :float)
  end
end

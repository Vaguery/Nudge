# deletes all items from the +:name+ stack
#

class NameFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :name)
  end
end

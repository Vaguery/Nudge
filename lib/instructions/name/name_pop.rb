# pops (and discards) the topmost item from the +:name+ stack
#

class NamePopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :name)
  end
end

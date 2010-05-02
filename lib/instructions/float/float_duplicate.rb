# makes and pushes a clone of the top item on the +:float+ stack
#
# *needs:* 1 +:float+
#
# *pushes:* 1 +:float+
#

class FloatDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :float)
  end
end

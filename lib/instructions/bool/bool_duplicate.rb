# makes and pushes a clone of the top item on the +:bool+ stack
#
# *needs:* 1 +:bool+
#
# *pushes:* 1 +:bool+
#

class BoolDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :bool)
  end
end

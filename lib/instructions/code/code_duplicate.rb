# makes and pushes a clone of the top item on the +:code+ stack
#
# *needs:* 1 +:code+
#
# *pushes:* 1 +:code+
#

class CodeDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :code)
  end
end

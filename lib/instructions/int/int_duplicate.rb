# makes and pushes a clone of the top item on the +:int: stack
#
# *needs:* 1 +:int+
#
# *pushes:* 1 +:int+
#

class IntDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :int)
  end
end

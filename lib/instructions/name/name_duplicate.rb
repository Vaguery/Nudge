# makes and pushes a clone of the top item on the +:name+ stack
#
# *needs:* 1 +:name+
#
# *pushes:* 1 +:name+
#

class NameDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :name)
  end
end

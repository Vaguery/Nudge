# makes and pushes a clone of the top item on the +:exec: stack
#
# *needs:* 1 +:exec+
#
# *pushes:* 1 +:exec+
#

class ExecDuplicateInstruction < Instruction
  include DuplicateInstruction
  def initialize(context)
    super(context, :exec)
  end
end

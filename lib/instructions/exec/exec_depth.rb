# pushes a ValuePoint with the number of items in the +:exec+ stack onto the +:int+ stack
#
# *pushes:* 1 +:int+
#

class ExecDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :exec)
  end
end

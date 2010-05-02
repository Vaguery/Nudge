# pushes a ValuePoint with the number of items in the +:code+ stack onto the +:int+ stack
#
# *pushes:* 1 +:int+
#

class CodeDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :code)
  end
end

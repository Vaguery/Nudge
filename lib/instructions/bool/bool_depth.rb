# pushes a ValuePoint with the number of items in the +:bool+ stack onto the +:int+ stack
#
# *pushes:* 1 +:int+
#

class BoolDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :bool)
  end
end

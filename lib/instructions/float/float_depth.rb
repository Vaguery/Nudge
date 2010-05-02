# pushes a ValuePoint with the number of items in the +:float+ stack onto the +:int+ stack
#
# *pushes:* 1 +:int+
#

class FloatDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :float)
  end
end

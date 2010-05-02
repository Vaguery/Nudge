# pushes a ValuePoint with the number of items in the +:int+ stack onto the +:int+ stack
#
# *pushes:* 1 +:int+
#

class IntDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :int)
  end
end

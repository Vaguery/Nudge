# pushes a ValuePoint with the number of items in the +:name+ stack onto the +:int+ stack
#
# *pushes:* 1 +:int+
#

class NameDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :name)
  end
end

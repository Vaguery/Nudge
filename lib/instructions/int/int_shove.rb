# pops the top 2 items of the +:int+ stack;
# pushes the top item down "into" the +:int+ stack, at a level determined by the second value.
# 
# If the destination value is negative or 0, the item stays on top;
# if the destination value is greater than or equal to the depth of the stack, the item goes to the bottom;
# otherwise, the item is inserted farther from the stack's top as the destination value increases.
# 
# note: the destination depth is calculated after the items have been popped
#
# *needs:* 2 +:int+
#
# *pushes:* 1 +:int+ (sortof)
#

class IntShoveInstruction < Instruction
  include ShoveInstruction
  def initialize(context)
    super(context, :int)
  end
end

# pops the top items of the +:float+ and +:int+ stacks;
# pushes the +:float+ down "into" the stack, at a level determined by the +:int+ "destination" value.
# 
# If the destination value is negative or 0, the item stays on top;
# if the destination value is greater than or equal to the depth of the stack, the item goes to the bottom;
# otherwise, the item is inserted farther from the stack's top as the destination value increases.
# 
# note: the destination depth is calculated after the items have been popped
#
# *needs:* 1 +:float+, 1 +:int+
#
# *pushes:* 1 +:float+ (sortof)
#

class FloatShoveInstruction < Instruction
  include ShoveInstruction
  def initialize(context)
    super(context, :float)
  end
end

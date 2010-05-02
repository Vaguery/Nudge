# pops the top item of the +:int+ stack (the "index");
# pushes a duplicate of an item from down "inside" the +:bool+ stack to its top.
# 
# If the index value is negative or 0, the bottom item on the stack is copied;
# if the index value is greater than or equal to the depth of the stack, the top item is copied;
# otherwise, the index value refers to the bottom-to-top order of stack items.
#
# *needs:* 1 +:int+, 1 +:bool+
#
# *pushes:* 1 +:bool+ (sortof)
#

class BoolYankdupInstruction < Instruction
  include YankdupInstruction
  def initialize(context)
    super(context, :bool)
  end
end

# pops the top item of the +:int+ stack (the "index");
# then repositions an item from down "inside" the +:name+ stack to its top.
# 
# If the index value is negative or 0, the bottom item on the stack is moved;
# if the index value is greater than or equal to the depth of the stack, there is no change;
# otherwise, the index value refers to the bottom-to-top order of stack items.
#
# *needs:* 1 +:int+, 1 +:name+
#
# *pushes:* 1 +:name+ (sortof)
#

class NameYankInstruction < Instruction
  include YankInstruction
  def initialize(context)
    super(context, :name)
  end
end

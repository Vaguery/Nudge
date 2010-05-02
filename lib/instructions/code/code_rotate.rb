# pops the top 3 items of the +:code+ stack;
# pushes them back in _rotated_ order
# 
# If they were A, B and C (with C originally at the top of the stack)
# the result will be B, C, A (with A at the top)
#
# *needs:* 3 +:code+
#
# *pushes:* 3 +:code+
#

class CodeRotateInstruction < Instruction
  include RotateInstruction
  def initialize(context)
    super(context, :code)
  end
end

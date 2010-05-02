# pops the top item of the +:bool+ stack and the +:name+ stack;
# if the name string is not a bound variable (as opposed to a local name),
# it binds the name to the +:bool+ ValuePoint
#
# *needs:* 1 +:bool+, 1 +:name+
#
# *pushes:* nothing
#

class BoolDefineInstruction < Instruction
  include DefineInstruction
  def initialize(context)
    super(context, :bool)
  end
end

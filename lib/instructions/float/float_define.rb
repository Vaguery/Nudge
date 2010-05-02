# pops the top item of the +:float+ stack and the +:name: stack;
# if the name string is not a bound variable (as opposed to a local name),
# it binds the name to the +:float+ ValuePoint
#
# *needs:* 1 +:float+, 1 :+name+
#
# *pushes:* nothing
#

class FloatDefineInstruction < Instruction
  include DefineInstruction
  def initialize(context)
    super(context, :float)
  end
end

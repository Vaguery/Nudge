# pops the top item of the +:exec+ stack and the +:name+ stack;
# if the name string is not a bound variable (as opposed to a local name),
# it binds the name to a new ValuePoint with type +:code+ and value derived from the +:exec+ item.
#
# *needs:* 1 +:exec+, 1 +:name+
#
# *pushes:* nothing
#

class ExecDefineInstruction < Instruction
  include DefineInstruction
  def initialize(context)
    super(context, :exec)
  end
end

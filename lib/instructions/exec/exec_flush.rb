# deletes all items from the +:exec+ stack
#
# note: this is the equivalent of a "BREAK" statement in many other languages
# 

class ExecFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :exec)
  end
end

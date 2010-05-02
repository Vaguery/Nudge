# pops the top item of the +:int+ stack and the +:name+ stack;
# if the name string is not a bound variable (as opposed to a local name),
# it binds the name to the +:int+ ValuePoint
#
# *needs:* 1 +:int+, 1 +:name+
#
# *pushes:* nothing
#

class IntDefineInstruction < Instruction
  include DefineInstruction
  def initialize(context) #:nodoc:
    super(context, :int)
  end
end

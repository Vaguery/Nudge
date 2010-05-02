# pops the top 2 items of the +:exec+ stack, and one +:bool+;
# returns the top +:exec+ item if the +:bool+ is +false+, the second one if +true+
#
# *needs:* 2 +:exec+, 1 +:bool+
#
# *pushes:* 1 +:exec+
#

class ExecIfInstruction < Instruction
  
  include IfInstruction
  
  def initialize(context)
    super(context, :exec)
  end
end

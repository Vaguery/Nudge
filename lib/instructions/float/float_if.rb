# pops the top 2 items of the +:float+ stack, and one +:bool+;
# returns the top +:float+ item if the +:bool+ is +false+, the second one if +true+
#
# *needs:* 2 +:float+, 1 +:bool+
#
# *pushes:* 1 +:float+
#

class FloatIfInstruction < Instruction
  
  include IfInstruction
  
  def initialize(context)
    super(context, :float)
  end
end

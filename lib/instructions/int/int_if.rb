# pops the top 2 items of the +:int+ stack, and one +:bool+;
# returns the top +:int+ item if the +:bool+ is +false+, the second one if +true+
#
# *needs:* 2 +:int+, 1 +:bool+
#
# *pushes:* 1 +:bool+
#

class IntIfInstruction < Instruction
  
  include IfInstruction
  
  def initialize(context)
    super(context, :int)
  end
end

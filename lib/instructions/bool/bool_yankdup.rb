class BoolYankdupInstruction < Instruction
  include YankdupInstruction
  def initialize(context)
    super(context, :bool)
  end
end

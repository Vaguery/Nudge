class IntYankdupInstruction < Instruction
  include YankdupInstruction
  def initialize(context)
    super(context, :int)
  end
end

class FloatYankdupInstruction < Instruction
  include YankdupInstruction
  def initialize(context)
    super(context, :float)
  end
end

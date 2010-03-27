class IntSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :int)
  end
end

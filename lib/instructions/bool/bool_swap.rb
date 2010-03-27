class BoolSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :bool)
  end
end

class CodeSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :code)
  end
end

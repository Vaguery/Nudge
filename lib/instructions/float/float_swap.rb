class FloatSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :float)
  end
end

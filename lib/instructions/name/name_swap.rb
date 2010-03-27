class NameSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :name)
  end
end

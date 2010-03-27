class ExecSwapInstruction < Instruction
  include SwapInstruction
  def initialize(context)
    super(context, :exec)
  end
end

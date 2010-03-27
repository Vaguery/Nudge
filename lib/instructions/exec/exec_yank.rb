class ExecYankInstruction < Instruction
  include YankInstruction
  def initialize(context)
    super(context, :exec)
  end
end

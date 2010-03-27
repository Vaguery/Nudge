class ExecYankdupInstruction < Instruction
  include YankdupInstruction
  def initialize(context)
    super(context, :exec)
  end
end

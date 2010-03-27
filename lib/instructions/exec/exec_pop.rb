class ExecPopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :exec)
  end
end

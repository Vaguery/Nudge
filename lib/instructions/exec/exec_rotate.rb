class ExecRotateInstruction < Instruction
  include RotateInstruction
  def initialize(context)
    super(context, :exec)
  end
end

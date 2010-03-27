class ExecDepthInstruction < Instruction
  include DepthInstruction
  def initialize(context)
    super(context, :exec)
  end
end

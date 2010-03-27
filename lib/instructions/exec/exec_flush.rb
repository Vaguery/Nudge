class ExecFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :exec)
  end
end

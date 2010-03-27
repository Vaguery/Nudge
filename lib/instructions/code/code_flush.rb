class CodeFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :code)
  end
end

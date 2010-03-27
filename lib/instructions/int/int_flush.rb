class IntFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :int)
  end
end

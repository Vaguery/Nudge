class BoolFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :bool)
  end
end

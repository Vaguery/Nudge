class NameFlushInstruction < Instruction
  include FlushInstruction
  def initialize(context)
    super(context, :name)
  end
end

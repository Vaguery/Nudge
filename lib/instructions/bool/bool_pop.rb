class BoolPopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :bool)
  end
end

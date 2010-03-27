class IntPopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :int)
  end
end

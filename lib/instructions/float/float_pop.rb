class FloatPopInstruction < Instruction
  include PopInstruction
  def initialize(context)
    super(context, :float)
  end
end

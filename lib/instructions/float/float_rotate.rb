class FloatRotateInstruction < Instruction
  include RotateInstruction
  def initialize(context)
    super(context, :float)
  end
end

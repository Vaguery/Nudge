class BoolRotateInstruction < Instruction
  include RotateInstruction
  def initialize(context)
    super(context, :bool)
  end
end

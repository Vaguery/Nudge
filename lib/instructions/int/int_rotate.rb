class IntRotateInstruction < Instruction
  include RotateInstruction
  def initialize(context)
    super(context, :int)
  end
end

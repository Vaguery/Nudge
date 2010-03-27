class NameRotateInstruction < Instruction
  include RotateInstruction
  def initialize(context)
    super(context, :name)
  end
end
